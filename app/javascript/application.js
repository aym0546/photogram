// Rails のベースライブラリ
import Rails from '@rails/ujs';
Rails.start();

// Turbo の読み込み
import '@hotwired/turbo-rails';

// グローバルライブラリ
import $ from 'jquery';
import axios from 'axios';

const csrfToken = document
  .querySelector('meta[name="csrf-token"]')
  .getAttribute('content');
axios.defaults.headers.common['X-CSRF-Token'] = csrfToken;

import * as ActiveStorage from '@rails/activestorage';
ActiveStorage.start();

// Stimulus Controllers
import './controllers';

import * as bootstrap from 'bootstrap';

document.addEventListener('turbo:load', () => {
  ////////////////////////////
  // アバター画像のアップロード //
  ////////////////////////////

  // 画像クリック → inputをトリガー
  $('#avatar-preview').on('click', () => {
    document.getElementById('avatar-input').click();
  });

  // ファイル選択 → Ajaxアップロード
  $('#avatar-input').on('change', function () {
    const file = this.files[0];
    if (!file) return;

    // FormData を使ってデータを構築
    const formData = new FormData();
    formData.append('user[avatar]', file);

    // アップロード送信
    axios
      .patch('/user', formData, {
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]')
            .content,
          'Content-Type': 'multipart/form-data',
        },
      })
      .then((res) => {
        if (res.data.avatar_url) {
          // 返ってきた avatar_url を使って再描写
          $('#avatar-preview').attr('src', res.data.avatar_url);
        }
        flash('プロフィール画像を更新しました');
      })
      .catch((e) => {
        console.error('Upload error', e);
        flash('アップロードに失敗しました');
      });
  });

  ////////////////////////////
  // ♡ クリックで「いいね」する //
  ////////////////////////////

  $('.post').each(function () {
    const $post = $(this);
    const postId = $post.data('post-id');

    // load 時にいいねステータスを取得
    axios.get(`/posts/${postId}/like`).then((res) => {
      const hasLiked = res.data.hasLiked;
      handleHeartDisplay(hasLiked, $post);
    });

    // ♡ がクリックされたとき
    $post.find('.inactive-heart').on('click', () => {
      axios.post(`/posts/${postId}/like`).then((res) => {
        if (res.data.status === 'ok') {
          handleHeartDisplay(true, $post);
        }
      });
    });

    $post.find('.active-heart').on('click', () => {
      axios.delete(`/posts/${postId}/like`).then((res) => {
        if (res.data.status === 'ok') {
          handleHeartDisplay(false, $post);
        }
      });
    });
  });

  ////////////////
  // コメント表示 //
  ////////////////
  const dataset = $(`#post-show`).data();
  const postId = dataset.postId;
  axios.get(`/posts/${postId}/comments.json`).then((res) => {
    const comments = res.data;
    comments.forEach((comment) => {
      $('.comments-container').append(
        `<div class="post-comment">
          <div class="comment-img">
            <a href="/users/${comment.user.id}">
              <img src="${comment.user.avatar_url}" alt="avatar">
            </a>
          </div>
          <div class="comment-text">
            <div class="comment-text-user">
              <a href="/users/${comment.user.id}">${comment.user.account}</a>
            </div>
            <div class="comment-text-body">${comment.body}</div>
          </div>
        </div>`
      );
    });
  });

  //////////////////////////////////////////
  // コメントを入力したら投稿ボタン ↑ を表示する //
  //////////////////////////////////////////
  $('.comment-body').on('input', function () {
    const value = $(this).val().trim();
    const $btn = $('.comment-btn');

    if (value.length > 0) {
      $btn.removeClass('offscreen');
    } else {
      $btn.addClass('offscreen');
    }
  });

  ///////////////////
  // コメント投稿機能 //
  ///////////////////
  $('.comment-btn').on('click', () => {
    const body = $('#comment_body').val();

    if (!body) {
      flash('コメントを入力してください');
    } else {
      axios
        .post(`/posts/${postId}/comments`, {
          comment: { body: body },
        })
        .then((res) => {
          const comment = res.data;
          $('.comments-container').append(
            `<div class="post-comment"><div class="comment-img"><img src="${comment.user.avatar_url}" alt="avatar"></div><div class="comment-text"><div class="comment-text-user">${comment.user.account}</div><div class="comment-text-body">${comment.body}</div></div></div>`
          );
          $('#comment_body').val('');
        })
        .catch((error) => {
          if (error.response && error.response.status === 422) {
            const errors = error.response.data.errors;
            if (errors && Array.isArray(errors)) {
              flash(`エラー： ${errors.join(', ')}`);
            } else {
              flash('コメントの投稿に失敗しました');
            }
          } else {
            flash('予期しないエラーが発生しました');
          }
        });
    }
  });
});

// flash 表示
function flash(message, type = 'notice') {
  const flash = $('.flash');

  // 要素が存在しない場合は何もしない
  if (flash.length === 0) {
    console.warn('.flash element is not found');
    return;
  }

  // クラスを設定
  flash.removeClass().addClass(`flash flash-${type}`);

  // メッセージ設定と表示
  flash.text(message).show();

  // 一定時間後に非表示（3秒）
  setTimeout(() => {
    flash.fadeOut(400);
  }, 3000);
}

// ♡ の差し替え
const handleHeartDisplay = (hasLiked, container) => {
  if (hasLiked) {
    container.find('.active-heart').removeClass('offscreen');
    container.find('.inactive-heart').addClass('offscreen');
  } else {
    container.find('.inactive-heart').removeClass('offscreen');
    container.find('.active-heart').addClass('offscreen');
  }
};
