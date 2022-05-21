# in IDDD book it's located in `com.saasovation.common.port.adapter.messaging.rabbitmq, so outside of specific subdomain
# this is an interface that each subdomain has to implement

class ExchangeListener

	def exchange_name
		raise 'Implement me'
	end

	def filtered_dispatch
		raise 'Implement me'
	end

	def listens_to_events
		raise 'Implement me'
	end

	def queue_name
		class.name.downcase
	end
	
	def attatch_to_queue
		# code
	end

	def queue
		# code
	end

	def register_consumer
		#code
	end
end