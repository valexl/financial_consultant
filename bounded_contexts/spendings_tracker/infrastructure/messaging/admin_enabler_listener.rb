class AdminEnablerListener < SharedKernel::Common::Port::Adapter::Messaging::Rabbitmq::ExchangeListener
  def exchange_name
    # name of the subscribed message
    # code
  end

  def filtered_dispatch
    # filter message before send it to application service
    # for example you may ingore some white list events (from listnes_to_events array) with specific data
    # code

    Application::Month::Service.do_something(command)
  end

  def listens_to_events
    [
      'month_started'
    ]
  end
end
