// get DPI by mesuring a `div` with 1 inch wide in pixels
const div = document.createElement('div');
div.style = 'background-color: transparent; height: 1in; width: 1in; position: absolute;';
document.body.appendChild(div);

native_dpi = div.offsetWidth;
scaled_dpi = div.offsetWidth * (window.devicePixelRatio || 1);

console.log(`Native DPI: ${native_dpi}`);
console.log(`Scaled DPI: ${scaled_dpi}`);

// send the DPI value to server
let json = JSON.stringify({
  dpi: scaled_dpi
})

fetch('/return_dpi', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: json
}).then(respond => {
  setTimeout(() => {
    // close this window after sending the result to the server
    try {
      window.close();
    } catch (err) {
      console.error(err);
      window.alert('This window can be closed now.');
    }
  }, 1000);
});