import $ from 'jquery';

export function flash(message, type = 'notice') {
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
