document.addEventListener("DOMContentLoaded", () => {
  const openModalButton = document.getElementById("open-modal");
  const closeModalButton = document.getElementById("close-modal");
  const modal = document.getElementById("modal");

  openModalButton.addEventListener("click", () => {
    modal.classList.remove("hidden");
  });

  closeModalButton.addEventListener("click", () => {
    modal.classList.add("hidden");
  });

  // Close modal if click outside of the modal content
  window.addEventListener("click", (event) => {
    if (event.target === modal) {
      modal.classList.add("hidden");
    }
  });
});
