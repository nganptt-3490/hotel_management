document.addEventListener("turbo:load", () => {
  const openModalButton = document.getElementById("open-modal");
  const closeModalButton = document.getElementById("close-modal");
  const modal = document.getElementById("modal");

  if (openModalButton && closeModalButton && modal) {
    openModalButton.addEventListener("click", () => {
      modal.classList.remove("hidden");
    });

    closeModalButton.addEventListener("click", () => {
      modal.classList.add("hidden");
    });

    window.addEventListener("click", (event) => {
      if (event.target === modal) {
        modal.classList.add("hidden");
      }
    });
  }

  const openModalButton2 = document.getElementById("open-modal-2");
  const closeModalButton2 = document.getElementById("close-modal-2");
  const modal2 = document.getElementById("modal-2");

  if (openModalButton2 && closeModalButton2 && modal2) {
    openModalButton2.addEventListener("click", () => {
      modal2.classList.remove("hidden");
    });

    closeModalButton2.addEventListener("click", () => {
      modal2.classList.add("hidden");
    });

    window.addEventListener("click", (event) => {
      if (event.target === modal2) {
        modal2.classList.add("hidden");
      }
    });
  }
});
