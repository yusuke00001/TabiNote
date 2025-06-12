import flatpickr from "flatpickr";

document.addEventListener("turbo:load", () => {
  flatpickr(".timepickr", {
    enableTime: true,
    noCalendar: true,
    dateFormat: "H:i",
    time_24hr: true,
    minuteIncrement: 15
  });
})