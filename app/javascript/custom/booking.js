document.addEventListener("turbo:load", function () {
  const bookingButton = document.getElementById("booking-button");
  const bookingForm = document.getElementById("booking-form");

  bookingButton?.addEventListener("click", function (e) {
    e.preventDefault();
    bookingForm.classList.toggle("hidden");
  });

  const bookingButton2 = document.getElementById("booking-button-2");
  const bookingForm2 = document.getElementById("booking-form-2");

  bookingButton2?.addEventListener("click", function (e) {
    e.preventDefault();
    bookingForm2.classList.toggle("hidden");
  });

  const form = document.getElementById("lost-utility-form");
  form?.addEventListener("submit", function (e) {
    e.preventDefault();
    const formData = new FormData(form);

    fetch(form.action, {
      method: form.method,
      headers: {
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']")
          .content,
        Accept: "application/json",
      },
      body: formData,
    })
      .then((response) => response.json())
      .then((data) => {
        if (data.success) {
          const newItem = document.createElement("li");
          newItem.textContent = `${data.utility_name} * ${
            data.lost_utility.quantity
          } : ${data.lost_utility.quantity * data.utility_cost}`;
          newItem.classList.add("text-black");
          document.querySelector("#modalb ul").appendChild(newItem);

          form.reset();
        } else {
          alert(data.errors.join(", "));
        }
      })
      .catch((error) => console.error("Error:", error));
  });
});
