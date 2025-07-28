import { Controller } from '@hotwired/stimulus';
import axios from 'axios';

// Connects to data-controller="comments"
export default class extends Controller {
  static targets = ['container', 'body', 'btn'];
  static values = { postId: Number };

  connect() {
    this.loadComments();
  }

  loadComments() {
    axios
      .get(`/posts/${this.postIdValue}/comments.json`)
      .then((res) => {
        res.data.forEach((comment) => this.appendComment(comment));
      })
      .catch((e) => {
        console.error('⚠️Failure to retrieve comments');
      });
  }

  // コメントを入力したら投稿ボタン ↑ を表示
  inputChanged() {
    const value = this.bodyTarget.value.trim();
    this.btnTarget.classList.toggle('offscreen', value.length === 0);
  }

  // コメント投稿機能
  submitComment() {
    const body = this.bodyTarget.value.trim();
    if (!body) return flash('コメントを入力してください');

    axios
      .post(`/posts/${this.postIdValue}/comments`, {
        comment: { body: body },
      })
      .then((res) => {
        this.appendComment(res.data);
        this.bodyTarget.value = '';
        this.inputChanged(); // btn 再非表示
      })
      .catch((error) => {
        const msg =
          error.response?.data?.errors?.join(', ') || '投稿に失敗しました';
        flash(`error: ${msg}`);
      });
  }

  appendComment(comment) {
    const commentHTML = this.buildCommentHTML(comment);
    this.containerTarget.insertAdjacentHTML('beforeend', commentHTML);
  }

  buildCommentHTML(comment) {
    const escape = (str) =>
      str
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#39;');

    return `
      <div class="post-comment">
        <div class="comment-img">
          <a href="/users/${comment.user.id}">
            <img src="${comment.user.avatar_url}" alt="avatar">
          </a>
        </div>
        <div class="comment-text">
          <div class="comment-text-user">
            <a href="/users/${comment.user.id}">${escape(comment.user.account)}</a>
          </div>
          <div class="comment-text-body">${escape(comment.body)}</div>
        </div>
      </div>
    `;
  }
}
