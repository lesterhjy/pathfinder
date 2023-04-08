class UserMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome.subject
  #
  def send_email
    @user = params[:user]
    @trip = params[:trip]

    mail(
      from: 'admin@pathfinder.city',
      to: @user.email,
      subject: "#{@user.trips.find(@trip.id).destination} Itinerary"
    )
    # This will render a view in `app/views/user_mailer`!
  end
end
