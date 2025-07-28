import { Controller } from '@hotwired/stimulus';
import axios from 'axios';

import { flash } from '../utils/flash';

// Connects to data-controller="avatar-update"
export default class extends Controller {
  static targets = ['input', 'preview'];

  connect() {
    console.log('AvatarUpdateController connected');
  }

  triggerFileInput() {
    this.inputTarget.click();
  }

  uploadAvatar() {
    const file = this.inputTarget.files[0];
    if (!file) return;

    const formData = new FormData();
    formData.append('user[avatar]', file);

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
          this.previewTarget.src = res.data.avatar_url;
        }
        flash('プロフィール画像を更新しました');
      })
      .catch((e) => {
        console.error('⚠️Upload error', e);
        flash('アップロードに失敗しました');
      });
  }
}
