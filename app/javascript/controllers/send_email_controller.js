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
    Swal.fire('Email Sent!', '', 'success');
  }
}
