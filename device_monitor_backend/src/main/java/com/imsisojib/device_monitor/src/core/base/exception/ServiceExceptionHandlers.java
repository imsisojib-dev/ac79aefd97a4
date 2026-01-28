package com.imsisojib.device_monitor.src.core.base.exception;

import com.imsisojib.device_monitor.src.core.base.response.BaseResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.validation.Errors;
import org.springframework.validation.FieldError;
import org.springframework.web.HttpMediaTypeNotSupportedException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;
import org.springframework.web.servlet.NoHandlerFoundException;

import java.util.HashMap;
import java.util.Map;

@Slf4j
@RestControllerAdvice
@RequiredArgsConstructor
public class ServiceExceptionHandlers {

    @ExceptionHandler(ServiceExceptionHolder.ResourceNotFoundException.class)
    public BaseResponse handleUserNotFoundException(final ServiceExceptionHolder.ResourceNotFoundException ex) {
        log.error(ex.getMessage());
        return BaseResponse.build(HttpStatus.NOT_FOUND).message(ex.getMessage());
    }

    @ResponseStatus(HttpStatus.BAD_REQUEST)
    @ExceptionHandler(ServiceExceptionHolder.ResourceNotFoundDuringWriteRequestException.class)
    public BaseResponse handleUserNotFoundException(final ServiceExceptionHolder.ResourceNotFoundDuringWriteRequestException ex) {
        log.error(ex.getMessage());
        return BaseResponse.build(HttpStatus.BAD_REQUEST).message(ex.getMessage());
    }

    @ResponseStatus(HttpStatus.BAD_REQUEST)
    @ExceptionHandler(ServiceExceptionHolder.ResourceAlreadyExistsException.class)
    public BaseResponse handleAlreadyExistsException(final ServiceExceptionHolder.ResourceAlreadyExistsException ex) {
        log.error(ex.getMessage());
        return BaseResponse.build(HttpStatus.BAD_REQUEST).message(ex.getMessage());
    }

    @ResponseStatus(HttpStatus.BAD_REQUEST)
    @ExceptionHandler(ServiceExceptionHolder.BadRequestException.class)
    public BaseResponse handleCustomizedBadRequestException(final ServiceExceptionHolder.BadRequestException ex) {
        log.error(ex.getMessage());
        return BaseResponse.build(HttpStatus.valueOf(ex.getCode())).message(ex.getMessage());
    }

    @ResponseStatus(HttpStatus.BAD_REQUEST)
    @ExceptionHandler(ServiceExceptionHolder.IllegalDateFormatException.class)
    public BaseResponse handleIllegalDateFormatException(final ServiceExceptionHolder.IllegalDateFormatException ex) {
        log.error(ex.getMessage());
        return BaseResponse.build(HttpStatus.BAD_REQUEST).message(ex.getMessage());
    }

    @ResponseStatus(HttpStatus.BAD_REQUEST)
    @ExceptionHandler(ServiceExceptionHolder.TokenValidationException.class)
    public BaseResponse handleTokenValidationException(final ServiceExceptionHolder.TokenValidationException ex) {
        log.error(ex.getMessage());
        return BaseResponse.build(HttpStatus.BAD_REQUEST).message(ex.getMessage());
    }


    @ResponseStatus(HttpStatus.UNSUPPORTED_MEDIA_TYPE)
    @ExceptionHandler(HttpMediaTypeNotSupportedException.class)
    public BaseResponse handleUnsupportedMediaType(final HttpMediaTypeNotSupportedException ex) {
        log.error(ex.getMessage());
        return BaseResponse.build(HttpStatus.UNSUPPORTED_MEDIA_TYPE).message(ex.getLocalizedMessage());
    }

    @ResponseStatus(HttpStatus.UNPROCESSABLE_ENTITY)
    @ExceptionHandler(HttpMessageNotReadableException.class)
    public BaseResponse handleValidationError(final HttpMessageNotReadableException ex) {
        log.error(ex.getMessage());
        return BaseResponse.build(HttpStatus.UNPROCESSABLE_ENTITY).message(ex.getMessage());
    }

    @ResponseStatus(HttpStatus.BAD_REQUEST)
    @ExceptionHandler(MethodArgumentTypeMismatchException.class)
    public BaseResponse handleInvalidRequestParam(final MethodArgumentTypeMismatchException ex) {
        log.error(ex.getMessage());
        return BaseResponse.build(HttpStatus.BAD_REQUEST).message("Invalid Request Parameters");
    }

    @ResponseStatus(HttpStatus.BAD_REQUEST)
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public BaseResponse handleValidationError(final MethodArgumentNotValidException ex) {

        Map<String, String> errors = new HashMap<>();
        ex.getBindingResult().getAllErrors().forEach((error) -> {
            String fieldName = ((FieldError) error).getField();
            String errorMessage = error.getDefaultMessage();
            errors.put(fieldName, errorMessage);
        });

        Errors validationErrors = ex.getBindingResult();
        String message = validationErrors.getErrorCount() + " invalid request parameters.";
        log.error(ex.getMessage());
        return BaseResponse.build(HttpStatus.BAD_REQUEST).body(errors).message(message);
    }

    @ResponseStatus(HttpStatus.NOT_FOUND)
    @ExceptionHandler(NoHandlerFoundException.class)
    public BaseResponse handleNoHandlerFoundError(final NoHandlerFoundException ex) {
        log.error(ex.getMessage());
        return BaseResponse.build(HttpStatus.NOT_FOUND).message("Invalid URL");
    }

    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    @ExceptionHandler(ServiceExceptionHolder.ServiceException.class)
    public BaseResponse handleInternalServerError(final ServiceExceptionHolder.ServiceException ex) {
        ex.printStackTrace();
        log.error(ex.getMessage());
        return BaseResponse.build(HttpStatus.INTERNAL_SERVER_ERROR).message(ex.getMessage());
    }


    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    @ExceptionHandler(Exception.class)
    public BaseResponse handleThrowable(final Exception ex) {
        ex.printStackTrace();
        log.error(ex.getMessage());
        return BaseResponse.build(HttpStatus.INTERNAL_SERVER_ERROR).message("Internal server error while processing request." + ex.getClass().getCanonicalName());
    }
}
