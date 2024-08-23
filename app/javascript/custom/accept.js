document.addEventListener('turbo:load', function() {
  const acceptButton = document.getElementById('accept-button');
  const acceptForm = document.getElementById('accept-form');
  const rejectButton = document.getElementById('reject-button');
  const rejectForm = document.getElementById('reject-form');

  rejectButton?.addEventListener('click', function(e) {
    e.preventDefault();
    rejectForm.classList.toggle('hidden');
    if (!acceptForm.classList.contains('hidden')) {
      acceptForm.classList.add('hidden');
    }
  });
  
  acceptButton?.addEventListener('click', function(e) {
    e.preventDefault();
    acceptForm.classList.toggle('hidden');
    if (!rejectForm.classList.contains('hidden')) {
      rejectForm.classList.add('hidden');
    }
  });
});
