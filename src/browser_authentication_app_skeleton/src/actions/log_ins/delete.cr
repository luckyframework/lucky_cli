class LogIns::Delete < BrowserAction
  delete "/sign_out" do
    sign_out
    flash.info = "You have been logged out"
    redirect to: LogIns::New
  end
end
