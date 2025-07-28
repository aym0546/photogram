import { Controller } from '@hotwired/stimulus';
import axios from 'axios';

// Connects to data-controller="comments"
export default class extends Controller {
  static targets = ['container'];
  static values = { postId: Number };

  connect() {
    axios
      .get(`/posts/${this.postIdValue}/comments.json`)
      .then((res) => {
        const comments = res.data;
        comments.forEach((comment) => {
          const commentHTML = this.buildCommentHTML(comment);
          this.containerTarget.insertAdjacentHTML('beforeend', commentHTML);
        });
      })
      .catch((e) => {
        console.error('⚠️Failure to retrieve comments');
      });
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
