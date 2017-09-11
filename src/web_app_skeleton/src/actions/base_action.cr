abstract class BaseAction < LuckyWeb::Action
  include LuckyWeb::Exposeable

  macro inherited
    # If something should always be exposed to your pages, expose them here.
    #
    # Example:
    #
    #  macro inherited
    #    expose :current_user
    #  end
    #
    #  def current_user
    #    find_the_user...
    #  end
    #
    # Then add an assign for it in your BasePage
  end
end
