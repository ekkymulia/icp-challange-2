import { icp_hello_world_motoko_backend } from "../../declarations/icp_hello_world_motoko_backend";

document.querySelector("form").addEventListener("submit", async (e) => {
  e.preventDefault();
  const button = e.target.querySelector("button");

  const mood = document.querySelector('input[name="mood"]:checked').value;

  button.setAttribute("disabled", true);

  try {
    console.log('mood', mood);
    const response = await icp_hello_world_motoko_backend.greet(mood);

    const parts = response.split(". See more info");

    const cleanedText = parts[0].trim();

    const data = JSON.parse(cleanedText);

    const messageContent = data.choices[0].message.content;

    document.getElementById("spirit-sentence").innerText = messageContent;

  } catch (error) {
    console.error('Error:', error);
    document.getElementById("spirit-sentence").innerText = "An error occurred while fetching the greeting.";
  } finally {
    button.removeAttribute("disabled");
  }

  return false;
});
