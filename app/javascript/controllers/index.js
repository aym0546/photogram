import { Application } from '@hotwired/stimulus';
import HelloController from './hello_controller';
import ImagePreviewController from './image_preview_controller';

const application = Application.start();
application.register('hello', HelloController);
application.register('image-preview', ImagePreviewController);

export { application };
