import { Controller } from '@hotwired/stimulus';
import axios from 'axios';

// Connects to data-controller="follow"
export default class extends Controller {
  static targets = ['span', 'followerCount'];
  static values = {
    followed: Boolean,
    userId: Number,
  };

  connect() {
    this.csrfToken = document
      .querySelector('meta[name="csrf-token"]')
      .getAttribute('content');
    console.log('FollowController connected');
  }

  toggleFollow(e) {
    const url = this.spanTarget.dataset.url;
    const method = this.spanTarget.dataset.method;

    fetch(url, {
      method: method,
      headers: {
        'X-CSRF-Token': this.csrfToken,
        'Content-Type': 'application/json',
        Accept: 'application/json',
      },
      body: JSON.stringify({ followed_id: this.userIdValue }),
    })
      .then((response) => response.json())
      .then((data) => {
        this.spanTarget.innerText = data.following ? 'Unfollow' : 'Follow';

        this.spanTarget.dataset.method = data.following ? 'DELETE' : 'POST';
        this.spanTarget.dataset.url = data.next_url;

        this.followerCountTarget.innerText = `${data.followers_count}`;
      })
      .catch((e) => {
        console.error('⚠️Follow/Unfollow failed', e);
      });
  }
}
