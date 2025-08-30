// Service worker registration script
// This ensures the app can work offline

if ('serviceWorker' in navigator) {
  window.addEventListener('load', function() {
    navigator.serviceWorker.register('/flutter_service_worker.js');
  });
}