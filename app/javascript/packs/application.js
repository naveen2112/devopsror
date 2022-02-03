// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import $ from 'jquery';
import jQuery from 'jquery';
import "bootstrap"
import "../stylesheets/application.scss"
import 'select2'
import 'select2/dist/css/select2.css'

window.jQuery = $;
window.$ = $;

Rails.start()
Turbolinks.start()
ActiveStorage.start()
global.$ = jQuery;

require('packs/jquery-validations')
require('devise/registrations/new')
require('devise/sessions/new')
require('devise/passwords/new')
require('devise/passwords/edit')
require('posts/new')
require('posts/edit')
require('users/profile')
require("posts/custom-multiselect")
require("posts/custom")
require("posts/index")