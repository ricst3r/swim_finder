document.addEventListener('DOMContentLoaded', function() {
  const starLabels = document.querySelectorAll('.star-rating label');
  const starInputs = document.querySelectorAll('.star-rating input');

  starLabels.forEach((label) => {
    label.addEventListener('mouseover', () => {
      const currentRating = label.getAttribute('for').replace('rating', '');
      updateStars(currentRating);
    });

    label.addEventListener('click', () => {
      const currentRating = label.getAttribute('for').replace('rating', '');
      document.querySelector(`#rating${currentRating}`).checked = true;
      updateStars(currentRating);
    });
  });

  document.querySelector('.star-rating').addEventListener('mouseout', () => {
    const checkedInput = document.querySelector('.star-rating input:checked');
    updateStars(checkedInput ? checkedInput.value : 0);
  });

  function updateStars(rating) {
    starLabels.forEach((label, index) => {
      const star = label.querySelector('i');
      if (index < rating) {
        star.classList.remove('bi-star');
        star.classList.add('bi-star-fill');
      } else {
        star.classList.remove('bi-star-fill');
        star.classList.add('bi-star');
      }
    });
  }

  // Initialize stars based on the current rating
  const initialRating = document.querySelector('.star-rating input:checked');
  if (initialRating) {
    updateStars(initialRating.value);
  }
});
