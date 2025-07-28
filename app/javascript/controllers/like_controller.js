import { Controller } from '@hotwired/stimulus';
import axios from 'axios';

// Connects to data-controller="like"
export default class extends Controller {
  static values = { postId: Number };
  static targets = ['activeHeart', 'inactiveHeart'];

  connect() {
    this.loadLikeStatus();
  }

  loadLikeStatus() {
    axios
      .get(`/posts/${this.postIdValue}/like`)
      .then((res) => {
        this.toggleHeart(res.data.hasLiked);
      })
      .catch((e) => {
        console.error('⚠️ Failed to load like status', e);
      });
  }

  like() {
    axios
      .post(`/posts/${this.postIdValue}/like`)
      .then((res) => {
        if (res.data.status === 'ok') {
          this.toggleHeart(true);
        }
      })
      .catch((e) => {
        console.error('⚠️ Failed to like post', e);
      });
  }

  unlike() {
    axios
      .delete(`/posts/${this.postIdValue}/like`)
      .then((res) => {
        if (res.data.status === 'ok') {
          this.toggleHeart(false);
        }
      })
      .catch((e) => {
        console.error('⚠️ Failed to unlike post', e);
      });
  }

  toggleHeart(hasLiked) {
    if (hasLiked) {
      this.activeHeartTarget.classList.remove('offscreen');
      this.inactiveHeartTarget.classList.add('offscreen');
    } else {
      this.inactiveHeartTarget.classList.remove('offscreen');
      this.activeHeartTarget.classList.add('offscreen');
    }
  }
}
