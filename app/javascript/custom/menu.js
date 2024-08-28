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

  const openModalButtona = document.getElementById("open-modal-a");
  const closeModalButtona = document.getElementById("close-modal-a");
  const modala = document.getElementById("modal-a");

  if (openModalButtona && closeModalButtona && modala) {
    openModalButtona.addEventListener("click", () => {
      modala.classList.remove("hidden");
    });

    closeModalButtona.addEventListener("click", () => {
      modala.classList.add("hidden");
    });

    window.addEventListener("click", (event) => {
      if (event.target === modala) {
        modala.classList.add("hidden");
      }
    });
  }

  document
    .querySelectorAll('[id^="open-modal-"]')
    .forEach((openModalButton) => {
      const id = openModalButton.id.split("-").pop();
      const modal = document.getElementById(`modal-${id}`);
      const closeModalButton = document.getElementById(`close-modal-${id}`);

      if (modal && closeModalButton) {
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
    });

  const openModalButtonb = document.getElementById("open-modal-b");
  const closeModalButtonb = document.getElementById("close-modal-b");
  const modalb = document.getElementById("modalb");

  if (openModalButtonb && closeModalButtonb && modalb) {
    openModalButtonb.addEventListener("click", () => {
      modalb.classList.remove("hidden");
    });

    closeModalButtonb.addEventListener("click", () => {
      modalb.classList.add("hidden");
    });

    window.addEventListener("click", (event) => {
      if (event.target === modalb) {
        modalb.classList.add("hidden");
      }
    });
  }
});
