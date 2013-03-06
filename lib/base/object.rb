class Bloxley::Base

  def call_cascade(methods, *params)
    meth = methods.detect { |m| respond_to? m }

    send(meth, *params) if meth
  end

  protected

    def min(a, b)
      a < b ? a : b
    end

    def max(a, b)
      a < b ? b : a
    end

end
