module WicketSDK
  # Allows warnings to be suppressed via environment variable.
  module Warnable
    # Wrapper around Kernel#warn to print warnings unless
    # WICKET_SDK_SILENT is set to true.
    #
    # @return [nil]
    def wicket_sdk_warn(*message)
      warn message unless ENV['WICKET_SDK_SILENT']
    end
  end
end
