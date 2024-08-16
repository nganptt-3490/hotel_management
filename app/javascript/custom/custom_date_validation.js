document.addEventListener('DOMContentLoaded', function() {
  const startDateInput = document.getElementById('hero-input-1');
  const endDateInput = document.getElementById('hero-input-2');

  const today = new Date().toISOString().split('T')[0];
  startDateInput.min = today;

  startDateInput.addEventListener('change', function() {
    const startDateValue = new Date(this.value);
    const minEndDate = new Date(startDateValue);
    minEndDate.setDate(minEndDate.getDate() + 1);
    endDateInput.min = minEndDate.toISOString().split('T')[0];
  });
});  
