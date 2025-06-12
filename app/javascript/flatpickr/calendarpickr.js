import flatpickr from "flatpickr";

document.addEventListener("turbo:load", () => {
  flatpickr(".calendarpickr", {
    minDate: "today",
  });
});