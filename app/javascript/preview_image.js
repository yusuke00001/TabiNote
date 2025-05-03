
function loadImage(obj) {
  const allPreview = document.getElementById('post_avatar');
  const newPreview = document.createElement("p");
  const oldPreview = allPreview.querySelector("p");
  if (oldPreview) {
    oldPreview.remove();
  }
  newPreview.setAttribute("id","preview");
  allPreview.insertBefore(newPreview, allPreview.firstChild);
  const fileReader = new FileReader();
      fileReader.onload = (function (e) {
        const img = new Image();
        img.src = e.target.result;
        img.classList.add("preview-avatar")
        document.getElementById('preview').appendChild(img);
      });
    fileReader.readAsDataURL(obj.files[0]);
}
window.loadImage = loadImage;