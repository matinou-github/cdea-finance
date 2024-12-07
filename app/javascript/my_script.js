// Test if jquery is loaded by typing $.fn.jquery in the console as per
// https://stackoverflow.com/questions/6973941/how-to-check-what-version-of-jquery-is-loaded/26674265#26674265



// This function runs on every page "load"
// document.addEventListener("turbo:load", () => {
//   const popoverTriggerList = document.querySelectorAll('[data-bs-toggle="popover"]');
//   const popoverList = [...popoverTriggerList].map((popoverTriggerEl) => new bootstrap.Popover(popoverTriggerEl));
// });

document.addEventListener("turbo:load", () => {
  // Détruit toutes les instances existantes pour éviter les doublons
  document.querySelectorAll('[data-bs-toggle="popover"]').forEach((el) => {
    const instance = bootstrap.Popover.getInstance(el);
    if (instance) {
      instance.dispose(); // Supprime l'instance existante
    }
  });

  // Réinitialise les popovers
  const popoverTriggerList = document.querySelectorAll('[data-bs-toggle="popover"]');
  popoverTriggerList.forEach((popoverTriggerEl) => {
    new bootstrap.Popover(popoverTriggerEl);
  });
});

document.addEventListener("turbo:load", () => {
  // Réinitialise ton JavaScript ici
  initializeSidebar(); // Une fonction pour reconfigurer ton sidebar
});


function initializeSidebar() {
  const sidebarToggle = document.querySelector("#sidebar-toggle");
  const sidebar = document.querySelector("#sidebar");

  if (sidebarToggle && sidebar) {
    sidebarToggle.addEventListener("click", () => {
      sidebar.classList.toggle("active");
    });
  }
}


