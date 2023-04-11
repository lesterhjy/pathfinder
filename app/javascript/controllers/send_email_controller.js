import { Controller } from "@hotwired/stimulus"
import Swal from "sweetalert2";


// Connects to data-controller="send-email"
export default class extends Controller {
  static targets = ["form"]

  connect() {
    console.log("send-email connected")
  }

  send() {
    console.log("form submitted")
    Swal.fire({text: 'Email sent!',
                title: '<i class="fa-solid fa-envelope-open-text" style="color: #D9534F"></i>',
                showConfirmButton: false,
                width: 400,
                background: '#fff0db',
                timer: 1500});
  }
}
