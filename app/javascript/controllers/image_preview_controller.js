import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="image-preview"
export default class extends Controller {
  static targets = ['input', 'output'];

  connect() {
  }

  preview() {
    // ファイルを取得
    const files = this.inputTarget.files;
    this.outputTarget.innerHTML = ''; // プレビュー領域を一旦クリア

    // ファイルごとにプレビュー画像を生成
    Array.from(files).forEach((file) => {
      if (!file.type.match('image.*')) return;

      const reader = new FileReader();

      reader.onload = (e) => {
        const img = document.createElement('img');
        img.src = e.target.result;
        img.classList.add('m-1', 'rounded', 'shadow-sm');
        img.style.maxWidth = '190px';
        this.outputTarget.appendChild(img);
      };
      reader.readAsDataURL(file);
    });
  }
}
