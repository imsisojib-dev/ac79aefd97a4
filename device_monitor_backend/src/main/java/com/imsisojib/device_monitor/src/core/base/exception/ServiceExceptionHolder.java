package com.imsisojib.device_monitor.src.core.base.exception;

import com.imsisojib.device_monitor.src.core.base.constants.Constants;
import lombok.Getter;
import org.springframework.http.HttpStatus;

import java.util.Arrays;

public class ServiceExceptionHolder {

	@Getter
	public static class ServiceException extends RuntimeException {
		private final int code;
		private final String message;

		public ServiceException(int code, String message) {
			super(code + " " + message);
            this.code = code;
            this.message = message;
        }
	}

	public static class ResourceNotFoundException extends ServiceException {
		public ResourceNotFoundException(String message) {
			super(404, message);
		}
	}

	public static class ResourceAlreadyExistsException extends ServiceException {
		public ResourceAlreadyExistsException(String message, String messageBn) {
			super(400, message);
		}
	}

	public static class ResourceInValidException extends ServiceException {
		public ResourceInValidException(String message, String messageBn) {
			super(400, message);
		}
	}

	public static class ResourceNotFoundDuringWriteRequestException extends ServiceException {
		public ResourceNotFoundDuringWriteRequestException(String message, String messageBn) {
			super(400, message);
		}
	}

	public static class IllegalDateFormatException extends ServiceException {
		public IllegalDateFormatException(String message, String messageBn) {
			super(HttpStatus.BAD_REQUEST.value(), message);
		}
	}

	public static class TokenValidationException extends ServiceException {
		public TokenValidationException(String message, String messageBn) {
			super(400, message);
		}
	}

	public static class BadRequestException extends ServiceException {
		public BadRequestException() {
			super(HttpStatus.BAD_REQUEST.value(), "Sorry, your request can't be processed.");
		}

		public BadRequestException(String message, String messageBn) {
			super(HttpStatus.BAD_REQUEST.value(), message);
		}

		public BadRequestException(String message) {
			super(HttpStatus.BAD_REQUEST.value(), message);
		}

		public BadRequestException(HttpStatus status, String message) {
			super(status.value(), message);
		}

		public BadRequestException(Exception e) {
			super(HttpStatus.BAD_REQUEST.value(), getErrorMessage(e));
			e.printStackTrace();
		}

		public static String getErrorMessage(Exception e) {
			try {
				String msgType = getMessageType(e.getMessage());
				if (msgType.equals("uk") || msgType.equals("re"))
					return Constants.DATA_ALRADY_EXISTS_MESSAGE;
				else if (msgType.equals("fk"))
					return Constants.CHILD_RECORD_FOUND;
				else {
					String[] subString = getNotNullMessage(e.getMessage());
					if (null == subString)
						return e.getMessage();
					if (subString.length > 0) {
						if (subString[1].equals("of relation"))
							return subString[0] + " can't be null";
						else
							return "Internal System Error";
					} else
						return "Internal System Error";
				}
			} catch (Exception ex) {
				e.printStackTrace();
				return e.getMessage();
			}
		}



		private static String getMessageType(String message) {
			if (message != null && message.length() > 55) {
				return message.substring(52, 54);
			}
			return "";
		}

		private static String[] getNotNullMessage(String message) {
			if (message != null && message.length() > 55) {
				String subString = message.substring(52);
				String[] splitted2 = Arrays.stream(subString.split("]")).map(String::trim).toArray(String[]::new);
				String[] splitted3 = Arrays.stream(splitted2[0].split("\"")).map(String::trim).toArray(String[]::new);
				return splitted3;
			}
			return null;
		}
	}

}