import { icp_hello_world_motoko_backend } from "../../declarations/icp_hello_world_motoko_backend";

document.querySelector("form").addEventListener("submit", async (e) => {
  e.preventDefault();
  const button = e.target.querySelector("button");

  // Get the selected mood (emoji value)
  const mood = document.querySelector('input[name="mood"]:checked').value;

  button.setAttribute("disabled", true);

  // Pass the selected mood to the backend instead of name
  console.log('mood', mood)
  const greeting = await icp_hello_world_motoko_backend.greet(mood);

  button.removeAttribute("disabled");

  document.getElementById("spirit-sentence").innerText = greeting;

  return false;
});
