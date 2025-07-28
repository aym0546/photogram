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
