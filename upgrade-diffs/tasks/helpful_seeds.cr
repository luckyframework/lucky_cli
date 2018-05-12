require "../spec/support/boxes/**"

# Only add sample data helpful for development, e.g. (fake users, blog posts, etc.)
#
# Use `Db::RequiredSeeds` if you need data required for your app to work.
class Db::HelpfulSeeds < LuckyCli::Task
  banner "Add sample database records helpful for development"

  def call
    # Using a LuckyRecord::Box:
    #
    # Use the defaults, but override just the email
    # UserBox.create &.email("me@example.com")

    # Using a form:
    #
    # UserForm.create!(email: "me@example.com", name: "Jane")
    puts "Done adding sample data"
  end
end
