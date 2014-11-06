class DataMailer < ActionMailer::Base
  default from: "no-reply@idrivealot.com"

  def monthly_data(user_id, report_string, data)
    @user = User.find(user_id)
    @download_data = data

    xlsx = render_to_string template: "mileage_records/aldi_log.xlsx.axlsx", locals: {current_user: @user}
    attachments["#{report_string}_log.xlsx"] = {mime_type: Mime::XLSX, content: xlsx}

    mail to: @user.email, subject: "#{report_string} - idrivealot.com"
  end

end
