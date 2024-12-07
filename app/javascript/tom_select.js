document.addEventListener('DOMContentLoaded', () => {
    // Initialisation de Tom-Select sur tous les éléments ayant la classe `select2`
    // const selectElements = document.querySelectorAll('.select2');
    // selectElements.forEach(function(select) {
    //   new TomSelect(select, {
    //     // Ajoute des options si nécessaire, comme la possibilité de rechercher
    //     create: true,   // Permet la création d'options nouvelles
    //     sortField: 'text',  // Tri les options par texte
    //   });
    // });

    document.querySelectorAll('.select-beast').forEach((select) => {
      new TomSelect(select, {
        create: false, // Désactiver la création de nouvelles options
        maxOptions: 100, // Limiter le nombre d'options affichées
        sortField: 'text',  // Tri les options par texte
      });
    });

  });
  
  
  // new TomSelect("#select-beast",{
  //   create: false,
  //   sortField: {
  //     field: "text",
  //     direction: "asc"
  //   }
  // });
  
  // document.addEventListener('DOMContentLoaded', () => {
  //   // Initialiser tous les champs avec la classe .select-beast
  //   document.querySelectorAll('.select-beast').forEach((select) => {
  //     new TomSelect(select, {
  //       create: false, // Désactiver la création de nouvelles options
  //       maxOptions: 100, // Limiter le nombre d'options affichées
  //     });
  //   });
  // });
  