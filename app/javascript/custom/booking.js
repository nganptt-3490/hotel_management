document.addEventListener('turbo:load', function() {
  const bookingButton = document.getElementById('booking-button');
  const bookingForm = document.getElementById('booking-form');
  
  bookingButton?.addEventListener('click', function(e) {
    e.preventDefault();
    bookingForm.classList.toggle('hidden');
  });
});
