// Rails のベースライブラリ
import Rails from "@rails/ujs"
Rails.start()

// Turbo の読み込み
import '@hotwired/turbo-rails';

// グローバルライブラリ
import $ from 'jquery';
import axios from 'axios';

// Stimulus Controllers
import './controllers';

document.addEventListener('turbo:load', () => {
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
        alert('プロフィール画像を更新しました');
      })
      .catch((e) => {
        console.error('Upload error', e);
        alert('アップロードに失敗しました');
      });
  });
});
