// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import AddEventController from "./add_event_controller"
application.register("add-event", AddEventController)

import AutocompleteController from "./autocomplete_controller"
application.register("autocomplete", AutocompleteController)

import DirectionsController from "./directions_controller"
application.register("directions", DirectionsController)

import EditEventController from "./edit_event_controller"
application.register("edit-event", EditEventController)

import EventsLoaderController from "./events_loader_controller"
application.register("events-loader", EventsLoaderController)

import FlatpickrController from "./flatpickr_controller"
application.register("flatpickr", FlatpickrController)

import FlatpickrEventsController from "./flatpickr_events_controller"
application.register("flatpickr-events", FlatpickrEventsController)

import FlatpickrFlightsController from "./flatpickr_flights_controller"
application.register("flatpickr-flights", FlatpickrFlightsController)

import FlatpickrHotelsController from "./flatpickr_hotels_controller"
application.register("flatpickr-hotels", FlatpickrHotelsController)

import FlightFormController from "./flight_form_controller"
application.register("flight-form", FlightFormController)

import FlipcardController from "./flipcard_controller"
application.register("flipcard", FlipcardController)

import HelloController from "./hello_controller"
application.register("hello", HelloController)

import HotelFormController from "./hotel_form_controller"
application.register("hotel-form", HotelFormController)

import LoadingController from "./loading_controller"
application.register("loading", LoadingController)

import MapsController from "./maps_controller"
application.register("maps", MapsController)

import NewEventsController from "./new_events_controller"
application.register("new-events", NewEventsController)

import SendEmailController from "./send_email_controller"
application.register("send-email", SendEmailController)

import SortableController from "./sortable_controller"
application.register("sortable", SortableController)

import ToggleController from "./toggle_controller"
application.register("toggle", ToggleController)

import TripFormController from "./trip_form_controller"
application.register("trip-form", TripFormController)

import TypedJsController from "./typed_js_controller"
application.register("typed-js", TypedJsController)

import { Application } from '@hotwired/stimulus'
import Clipboard from 'stimulus-clipboard'

const clipboard = Application.start()
clipboard.register('clipboard', Clipboard)
