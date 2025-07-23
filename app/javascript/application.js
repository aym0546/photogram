// Rails のベースライブラリ
import Rails from '@rails/ujs';
Rails.start();

// Turbo の読み込み
import '@hotwired/turbo-rails';

// グローバルライブラリ
import $ from 'jquery';
import axios from 'axios';

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

  ///////////////////////////////////////
  // 「いいね」の情報を取得して❤️を出し分ける //
  ///////////////////////////////////////

  const dataset = $(`#post-show`).data();
  const postId = dataset.postId;
  axios.get(`/posts/${postId}/like`).then((response) => {
    const hasLiked = response.data.hasLiked;

    if (hasLiked) {
      $('.active-heart').removeClass('offscreen');
    } else {
      $('.inactive-heart').removeClass('offscreen');
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
