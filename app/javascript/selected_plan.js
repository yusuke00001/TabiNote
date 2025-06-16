document.addEventListener("turbo:load", () => {
  const plan_containers = document.querySelectorAll(".plan-container");
  plan_containers.forEach(plan => {
    const button = plan.querySelector(".selected-button");
    if (button) {
      button.addEventListener("click", () => {
      plan_containers.forEach(plan => plan.classList.remove("is-selected"));
      plan.classList.add("is-selected");
      const selected_plan_id = plan.dataset.planId

      const hiddenField = document.getElementById("selected_plan_id_field");
      if (hiddenField) {
        hiddenField.value = selected_plan_id;
      }
      });
    }
  });
});