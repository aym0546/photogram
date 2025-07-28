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

import { flash } from './utils/flash';

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
});

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
