package com.imsisojib.device_monitor.src.core.base.services;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.imsisojib.device_monitor.src.core.base.dtos.BaseDto;
import com.imsisojib.device_monitor.src.core.base.dtos.DateRangeFilterDto;
import com.imsisojib.device_monitor.src.core.base.dtos.LoggedInUserDto;
import com.imsisojib.device_monitor.src.core.base.entities.BaseEntity;
import com.imsisojib.device_monitor.src.core.base.exception.ServiceExceptionHolder;
import com.imsisojib.device_monitor.src.core.base.model.MetaModel;
import com.imsisojib.device_monitor.src.core.base.model.SortModel;
import com.imsisojib.device_monitor.src.core.base.repositories.BaseRepository;
import com.imsisojib.device_monitor.src.core.base.request.BaseRequest;
import com.imsisojib.device_monitor.src.core.base.response.BaseResponse;
import com.imsisojib.device_monitor.src.core.base.util.UtilValidate;
import lombok.Data;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.reflect.FieldUtils;
import org.modelmapper.ModelMapper;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.BeanWrapper;
import org.springframework.beans.BeanWrapperImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;

import javax.persistence.criteria.*;
import java.beans.PropertyDescriptor;
import java.lang.reflect.Field;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;


@Slf4j
@Component
@RequiredArgsConstructor
@Data
public abstract class BaseService<E extends BaseEntity, D extends BaseDto> {
    @Autowired
    protected LoggedInUserDto loggedInUserDto;

    @Autowired
    protected ObjectMapper objectMapper;


    @Autowired
    protected UtilValidate utilValidate;

    private final BaseRepository<E> repository;

    @Autowired
    protected ModelMapper modelMapper;

    @Autowired
    protected Gson gson;


    protected String getLoggedInUserId() {
        return null != loggedInUserDto && null != loggedInUserDto.getUserId() ? loggedInUserDto.getUserId().toString() : UUID.randomUUID().toString();
    }

    private Class<D> getDtoClass() {
        return (Class<D>) (((ParameterizedType) getClass().getGenericSuperclass()).getActualTypeArguments()[1]);
    }

    private Class<E> getEntityClass() {
        return (Class<E>) (((ParameterizedType) getClass().getGenericSuperclass()).getActualTypeArguments()[0]);
    }

    protected E putBaseEntityDetailsForCreate(E entity) {
        entity.setCreatedBy(getLoggedInUserId());
        entity.setCreatedAt(LocalDateTime.now());
        entity.setIsDeleted(false);
        return entity;
    }

    public D convertForRead(E e) {
        return modelMapper.map(e, getDtoClass());
    }

    public List<D> convertForRead(List<E> e) {
        return e.stream().map(this::convertForRead).collect(Collectors.toList());
    }


    protected E convertForCreate(D d) {
        E e = null;
        try {
            e = getEntityClass().newInstance();
        } catch (InstantiationException | IllegalAccessException ex) {
            ex.printStackTrace();
        }
        BeanUtils.copyProperties(d, e);
        return e;
    }

    public E getEntityFromDtoForCreate(D dto) {
        return putBaseEntityDetailsForCreate(convertForCreate(dto));
    }

    public E createEntity(D dto) {
        if (!isValidWhileCreate(dto))
            throw new ServiceExceptionHolder.ResourceNotFoundDuringWriteRequestException("Sorry, can't create this time.", "কিছু ভুল হয়েছে");
        E entity = preCreate(getEntityFromDtoForCreate(dto));
        E createdEntity = repository.save(entity);
        postCreate(dto, createdEntity);
        return createdEntity;
    }

    public E createEntity(E e) {
        E entity = preCreate(e);
        E createdEntity = repository.save(entity);
        return createdEntity;
    }

    protected E preCreate(E entity) {
        return entity;
    }

    protected void postCreate(D dto, E entity) {
    }

    protected void postCreateAll(List<D> dtos, List<E> entities) {
    }

    protected boolean isValidWhileCreate(D dto) {
        return true;
    }

    public D create(D dto) {
        return convertForRead(createEntity(dto));
    }

    public List<D> create(List<D> dtos) {

        List<E> entities = new ArrayList<>();
        E e;
        for (D dto : dtos) {
            if (!isValidWhileCreate(dto)) continue;
            e = getEntityFromDtoForCreate(dto);
            entities.add(e);
        }
        List<E> createdEntities = repository.saveAll(entities);
        postCreateAll(dtos, createdEntities);
        return createdEntities.stream().map(o -> convertForRead(o)).collect(Collectors.toList());
    }

    public E createWithEntity(E entity) {
        E createdEntity = repository.save(putBaseEntityDetailsForCreate(entity));
        return createdEntity;
    }


    //CREATE: END-----------------------------------------------------------------------------------------------------------------------------------

    //UPDATE: START-----------------------------------------------------------------------------------------------------------------------------------

    protected E putBaseEntityDetailsForUpdate(E entity) {
        entity.setUpdatedBy(getLoggedInUserId());
        entity.setUpdatedAt(LocalDateTime.now());
        entity.setIsDeleted(false);
        return entity;
    }

    public E getEntityFromDtoForUpdate(D dto, E entity) {
        return putBaseEntityDetailsForUpdate(convertForUpdate(dto, entity));
    }

    protected D preUpdate(D dto) {
        return dto;
    }

    public D update(D dto) {
        if (!isValidWhileUpdate(dto))
            throw new ServiceExceptionHolder.ResourceNotFoundDuringWriteRequestException("Sorry, nothing found to be updated.", "কিছু ভুল হয়েছে");
        ;
        E entity = putBaseEntityDetailsForUpdate(convertForUpdate(preUpdate(dto), getEntityById(dto.getId())));
        E updatedEntity = repository.save(entity);
        postUpdate(dto, updatedEntity);
        return convertForRead(updatedEntity);
    }

    public List<D> update(List<D> dtos) {
        List<E> updatedEntities = new ArrayList<>();
        E e;
        for (D dto : dtos) {
            if (!isValidWhileUpdate(dto)) continue;
            e = putBaseEntityDetailsForUpdate(convertForUpdate(dto, getEntityById(dto.getId())));
            updatedEntities.add(e);
        }
        updatedEntities = repository.saveAll(updatedEntities);
        postUpdateAll(dtos, updatedEntities);
        return updatedEntities.stream().map(o -> convertForRead(o)).collect(Collectors.toList());
    }

    public E updateEntity(E entity) {
        return repository.save(putBaseEntityDetailsForUpdate(entity));
    }

    public List<E> updateEntities(List<E> entities) {
        return repository.saveAll(entities.stream().map(e -> putBaseEntityDetailsForUpdate(e)).collect(Collectors.toList()));
    }

    protected boolean isValidWhileUpdate(D dto) {
        if (dto.getId() == null) return false;
        return true;
    }

    protected E convertForUpdate(D d, E e) {
        copyNonNullProperties(d, e);
        return e;
    }

    public static void copyNonNullProperties(Object source, Object destination) {
        BeanUtils.copyProperties(source, destination, getNullPropertyNames(source));
    }

    public static String[] getNullPropertyNames(Object source) {
        final BeanWrapper src = new BeanWrapperImpl(source);
        PropertyDescriptor[] pds = src.getPropertyDescriptors();

        Set<String> emptyNames = new HashSet<String>();
        for (PropertyDescriptor pd : pds) {
            Object srcValue = src.getPropertyValue(pd.getName());
            if (srcValue == null) emptyNames.add(pd.getName());
        }

        String[] result = new String[emptyNames.size()];
        return emptyNames.toArray(result);
    }

    public static String[] getNotNullPropertyNames(Object source) {
        final BeanWrapper src = new BeanWrapperImpl(source);
        PropertyDescriptor[] pds = src.getPropertyDescriptors();

        Set<String> emptyNames = new HashSet<String>();
        for (PropertyDescriptor pd : pds) {
            Object srcValue = src.getPropertyValue(pd.getName());
            if (srcValue != null) emptyNames.add(pd.getName());
        }

        String[] result = new String[emptyNames.size()];
        return emptyNames.toArray(result);
    }

    protected void postUpdateAll(List<D> dtos, List<E> entities) {
    }

    protected void postUpdate(D dto, E entity) {
    }

    //UPDATE: END-----------------------------------------------------------------------------------------------------------------------------------


    //DELETE: START---------------------------------------------------------------------------------------------------------------------------------

    public D delete(E entity) {
        return convertForRead(repository.save(putBaseEntityDetailsForDelete(entity)));
    }

    public D delete(Long uuid) {
        return delete(getEntityById(uuid));
    }

    public List<D> delete(List<E> entities) {
        entities = entities.stream().map(e -> putBaseEntityDetailsForDelete(e)).collect(Collectors.toList());
        return convertForRead(repository.saveAll(entities));
    }

    public List<D> delete(Set<Long> idSet) {
        return delete(getListOfEntitiesByIdSet(idSet));
    }

    protected List<E> getListOfEntitiesByIdSet(Set<Long> idSet) {
        return repository.findAllById(idSet)
                .stream()
                .filter(e -> !e.getIsDeleted())
                .collect(Collectors.toList());
    }


    public E deleteEntity(E entity) {
        return repository.save(putBaseEntityDetailsForDelete(entity));
    }

    public List<E> deleteEntities(List<E> entities) {
        entities = entities.stream().map(e -> putBaseEntityDetailsForDelete(e)).collect(Collectors.toList());
        return repository.saveAll(entities);
    }

    protected E putBaseEntityDetailsForDelete(E entity) {
        entity.setUpdatedBy(getLoggedInUserId());
        entity.setUpdatedAt(LocalDateTime.now());
        entity.setIsDeleted(true);
        entity.setDeletedAt(LocalDateTime.now());
        return entity;
    }

    protected E getEntityById(@NonNull Long id) {
        return getOptionalEntity(id).orElseThrow(() -> new RuntimeException("Nothing found with id=" + id));
    }

    public Optional<E> getOptionalEntity(@NonNull Long id) {
        return repository.findByIdAndIsDeleted(id, false);
    }

    public D get(Long id) {
        return convertForRead(getEntityById(id));
    }

//    public BaseResponse getList(){
//        List<E> results = repository.findAll();
//        return BaseResponse.build(HttpStatus.OK).body(convertForRead(results));
//    }


    public BaseResponse getList(BaseRequest<D> requestDTO) {
        if(UtilValidate.noData(requestDTO))
            requestDTO = new BaseRequest<>();
        boolean hasMetaData = requestDTO.getMeta() != null && requestDTO.getMeta().getLimit() != null && requestDTO.getMeta().getPage() != null;
        D filter = null;
        try {
            filter = !UtilValidate.noData(requestDTO.getBody()) ? requestDTO.getBody() : getDtoClass().newInstance();
        } catch (InstantiationException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        }

        if(!utilValidate.noData(requestDTO.getMapOfBody()) && !requestDTO.getMapOfBody().isEmpty()) {
            if (hasMetaData) {
                Specification predicate = findByCriteria(requestDTO.getMapOfBody());

                Page<E> page = repository.findAll(predicate, getPageable(requestDTO.getMeta()));
                return BaseResponse.build(HttpStatus.OK).meta(getMeta(requestDTO.getMeta(), page)).body(convertForRead(page.getContent()));
            }

            List<E> results = repository.findAll(findByCriteria(requestDTO.getMapOfBody()));
            return BaseResponse.build(HttpStatus.OK).body(convertForRead(results));
        }else {
            if (hasMetaData) {
                Page<E> page = repository.findAll(findByCriteria(filter), getPageable(requestDTO.getMeta()));
                return BaseResponse.build(HttpStatus.OK).meta(getMeta(requestDTO.getMeta(), page)).body(convertForRead(page.getContent()));
            }

            List<E> results = repository.findAll(findByCriteria(filter));
            return BaseResponse.build(HttpStatus.OK).body(convertForRead(results));
        }
    }

    public MetaModel getMeta(MetaModel meta, Page page) {
        if (page.hasContent()) {
            meta.setTotalRecords(page.getTotalElements());
            meta.setTotalPageCount(page.getTotalPages());
            meta.setResultCount(page.getNumberOfElements());
        }
        Integer currentPage = meta.getPage();
        if (null != currentPage) {
            Integer prevPage = currentPage - 1;
            Integer nextPage = currentPage + 1;
            if (prevPage < 0) prevPage = 0;
            if (nextPage == page.getTotalPages()) nextPage -= 1;
            if (page.getTotalElements() == 0) nextPage = 0;
            meta.setPrevPage(prevPage);
            meta.setNextPage(nextPage);
        }
        return meta;
    }

    public Pageable getPageable(MetaModel meta) {
        if (meta == null || meta.getPage() == null || meta.getLimit() == null) return null;
        // has sorted properties inside meta
        if (null != meta.getSort() && meta.getSort().size() > 0)
            return PageRequest.of(meta.getPage(), meta.getLimit(), Sort.by(getSortOrders(meta.getSort())));
        else {
            return PageRequest.of(meta.getPage(), meta.getLimit(), Sort.by(getSortOrders(new ArrayList<SortModel>())));
        }
        // has no sorted properties inside meta
//        return PageRequest.of(meta.getPage(), meta.getLimit());
    }

    public List<Sort.Order> getSortOrders(List<SortModel> sortModels) {
        List<Sort.Order> orders = new ArrayList<>();
        if (null != sortModels && sortModels.size() > 0)
            sortModels.stream().forEach(model -> {
                if (null != model.getField() && null != model.getOrder()
                        && !model.getField().isEmpty() && !model.getOrder().isEmpty()) {
                    orders.add(new Sort.Order(getDirection(model.getOrder()), model.getField()));
                }
            });
        orders.add(new Sort.Order(Sort.Direction.DESC, "createdAt"));
        return orders;
    }

    private Sort.Direction getDirection(String order) {
        return null != order && order.equalsIgnoreCase(Sort.Direction.DESC.toString()) ? Sort.Direction.DESC : Sort.Direction.ASC;
    }

    protected Specification<E> findByCriteria(D dto) {
        return new Specification<E>() {

            @Override
            public Predicate toPredicate(Root<E> root, CriteriaQuery<?> criteriaQuery, CriteriaBuilder criteriaBuilder)
                    throws IllegalAccessError {
                List<Predicate> predicates = new ArrayList<>();
                // get all available fields from the dto class and it's parents
                Field[] fields = FieldUtils.getAllFields(dto.getClass());
                if (fields == null || fields.length == 0)
                    throw new ServiceExceptionHolder.BadRequestException("DTO does not contain any field");

                // iterate fields and prepare search criteria
                for (Field field : fields) {
                    try {
                        String fieldName = field.getName();
                        String fieldValue = null;
                        if (!field.getType().equals(DateRangeFilterDto.class)) {
                            fieldValue = extractFieldValue(field, dto);

                            if (null == fieldValue)
                                continue;
                        }
                        // add search criteria depending on field type
                        if (field.getType() == UUID.class)
                            predicates.add(criteriaBuilder
                                    .and(criteriaBuilder.equal(root.get(fieldName), UUID.fromString(fieldValue))));
                        else if (field.getType() == Integer.class)
                            predicates.add(criteriaBuilder
                                    .and(criteriaBuilder.equal(root.get(fieldName), Integer.valueOf(fieldValue))));
                        else if (field.getType() == Long.class)
                            predicates.add(criteriaBuilder
                                    .and(criteriaBuilder.equal(root.get(fieldName), Long.valueOf(fieldValue))));
                        else if (field.getType() == Boolean.class)
                            predicates.add(criteriaBuilder
                                    .and(criteriaBuilder.equal(root.get(fieldName), Boolean.valueOf(fieldValue))));
                        else if (field.getType() == Float.class)
                            predicates.add(criteriaBuilder
                                    .and(criteriaBuilder.equal(root.get(fieldName), Float.valueOf(fieldValue))));
                        else if (field.getType() == Double.class)
                            predicates.add(criteriaBuilder
                                    .and(criteriaBuilder.equal(root.get(fieldName), Double.valueOf(fieldValue))));
                        else if (field.getType() == String.class)
                            predicates.add(criteriaBuilder.and(criteriaBuilder.like(
                                    criteriaBuilder.lower(root.get(fieldName)), "%" + fieldValue.toLowerCase() + "%")));
                        else if (field.getType().isEnum()) {
                            @SuppressWarnings("unchecked")
                            Class<Enum> enumType = (Class<Enum>) field.getType();
                            try {
                                Enum enumValue = Enum.valueOf(enumType, fieldValue);
                                predicates.add(criteriaBuilder.equal(root.get(fieldName), enumValue));
                            } catch (IllegalArgumentException ex) {
                                throw new ServiceExceptionHolder.BadRequestException("Invalid enum value for field: " + fieldName);
                            }
                        }else if (Set.class.isAssignableFrom(field.getType())) {
                            // Possibly a Set<Enum>
                            Type genericType = field.getGenericType();
                            if (genericType instanceof ParameterizedType) {
                                ParameterizedType pt = (ParameterizedType) genericType;
                                Type actualTypeArg = pt.getActualTypeArguments()[0];
                                if (actualTypeArg instanceof Class && ((Class<?>) actualTypeArg).isEnum()) {
                                    @SuppressWarnings("unchecked")
                                    Class<Enum> enumType = (Class<Enum>) actualTypeArg;

                                    Object rawValue = FieldUtils.readField(dto, field.getName(), true);
                                    if (rawValue instanceof Set<?>) {
                                        Set<?> rawSet = (Set<?>) rawValue;

                                        Set<Enum> enumValues = rawSet.stream()
                                                .filter(Objects::nonNull)
                                                .map(v -> Enum.valueOf(enumType, v.toString()))
                                                .collect(Collectors.toSet());

                                        if (!enumValues.isEmpty()) {
                                            // Automatically map 'statusSet' to 'status', 'typeList' to 'type', etc.
                                            String entityFieldName = field.getName()
                                                    .replaceAll("(Set|List|Values|Filter)$", "");

                                            predicates.add(root.get(entityFieldName).in(enumValues));
                                        }
                                    }
                                }
                            }
                        }
                        else if (field.getType() == java.sql.Date.class)
                            predicates.add(criteriaBuilder.and(
                                    criteriaBuilder.equal(root.get(fieldName), java.sql.Date.valueOf(fieldValue))));
                        else if (field.getType() == Date.class)
                            predicates.add(criteriaBuilder.and(criteriaBuilder.equal(root.get(fieldName),
                                    FieldUtils.readField(dto, fieldName, true))));
                        else if (field.getType() == Timestamp.class)
                            predicates.add(criteriaBuilder.and(criteriaBuilder.equal(root.get(fieldName),
                                    Timestamp.valueOf(fieldValue))));
                        else if (field.getType().equals(DateRangeFilterDto.class)) {
                            Object objValue = FieldUtils.readField(dto, fieldName, true);
                            if (objValue != null && objValue instanceof DateRangeFilterDto) {
                                DateRangeFilterDto dateRangeFilter = (DateRangeFilterDto) FieldUtils.readField(dto, fieldName, true);
                                if (!utilValidate.noData(dateRangeFilter) && !utilValidate.noData(dateRangeFilter.getField())
                                        && !utilValidate.noData(dateRangeFilter.getStartDate()) && !utilValidate.noData(dateRangeFilter.getEndDate())) {

                                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
                                    LocalDateTime startTime = LocalDateTime.parse(dateRangeFilter.getStartDate() + " 00:00:00", formatter);
                                    LocalDateTime endTime = LocalDateTime.parse(dateRangeFilter.getEndDate() + " 23:59:59", formatter);
//                                    Date startDate = Date.from(startTime.atZone(ZoneId.systemDefault()).toInstant());
//                                    Date endDate = Date.from(endTime.atZone(ZoneId.systemDefault()).toInstant());

                                    predicates.add(criteriaBuilder
                                            .and(criteriaBuilder.between(root.get(dateRangeFilter.getField()), startTime, endTime)));
                                }
                            }
                        } else if (field.getType().getGenericSuperclass() == BaseDto.class) {
                            Join<E, ?> sts = root.join(fieldName);
                            predicates.add(criteriaBuilder
                                    .and(criteriaBuilder.equal(sts.get("id"), Long.valueOf(fieldValue))));
                        } else
                            throw new ServiceExceptionHolder.BadRequestException(
                                    "Invalid type for dto search field " + field.getType());
                    } catch (Exception e) {
                        log.error(e.getMessage());
                        throw new ServiceExceptionHolder.BadRequestException(e.getMessage());
                    }
                }
                // by default deleted data will not appears
                predicates.add(criteriaBuilder.and(criteriaBuilder.equal(root.get("isDeleted"), false)));

                return criteriaBuilder.and(predicates.toArray(new Predicate[predicates.size()]));
            }
        };
    }

    public String extractFieldValue(Field field, D dto) {
        String fieldName = field.getName();
        String fieldValue = null;
//        Gson gson;
        try {
            if (field.getType().getGenericSuperclass() == BaseDto.class) {
//                gson = new GsonBuilder().setDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ").create();
                if (objectMapper.readTree(gson.toJson(dto)).get(fieldName) == null) return null;
                JsonNode node = objectMapper.readTree(gson.toJson(dto)).get(fieldName).get("id");
                if (node != null) fieldValue = node.toString().replace("\"", "");
            } else fieldValue = FieldUtils.readField(dto, fieldName, true) + "";
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        }
        // skip field if field is transient or has no field value
        if ((utilValidate.noData(fieldValue)) || utilValidate.isTransient(dto.getClass(), fieldName)) return null;

        return fieldValue;
    }

    protected Predicate like(CriteriaBuilder criteriaBuilder, Expression<String> expression, String value) {
        return criteriaBuilder.like(criteriaBuilder.upper(expression), "%" + value.toUpperCase() + "%");
    }




    protected Specification<E> findByCriteria(Map<String, D> request) {
        return (Root<E> root, CriteriaQuery<?> query, CriteriaBuilder cb) -> {
            List<Predicate> andPredicates = new ArrayList<>();
            List<Predicate> orPredicates = new ArrayList<>();

            for (Map.Entry<String, D> entry : request.entrySet()) {
                String key = entry.getKey();
                D dto = entry.getValue();

                List<Predicate> fieldPredicates = new ArrayList<>();

                Field[] fields = FieldUtils.getAllFields(dto.getClass());
                if (fields == null || fields.length == 0) {
                    throw new ServiceExceptionHolder.BadRequestException("DTO does not contain any field");
                }

                for (Field field : fields) {
                    try {
                        String fieldName = field.getName();
                        String fieldValue = null;

                        if (!field.getType().equals(DateRangeFilterDto.class)) {
                            fieldValue = extractFieldValue(field, dto);
                            if (fieldValue == null) continue;
                        }

                        Predicate predicate = null;

                        // Ensure the field exists in the entity before using it
                        if (!root.getModel().getAttributes().stream().anyMatch(a -> a.getName().equals(fieldName))) {
                            if(!fieldName.startsWith("dateRangeFilter")) {
                                log.warn("Skipping non-existent field: {}", fieldName);
                                continue;
                            }
                        }

                        if (field.getType() == UUID.class) {
                            predicate = cb.equal(root.get(fieldName), UUID.fromString(fieldValue));
                        } else if (field.getType() == Integer.class) {
                            predicate = cb.equal(root.get(fieldName), Integer.valueOf(fieldValue));
                        } else if (field.getType() == Long.class) {
                            predicate = cb.equal(root.get(fieldName), Long.valueOf(fieldValue));
                        } else if (field.getType() == Boolean.class) {
                            predicate = cb.equal(root.get(fieldName), Boolean.valueOf(fieldValue));
                        } else if (field.getType() == Float.class) {
                            predicate = cb.equal(root.get(fieldName), Float.valueOf(fieldValue));
                        } else if (field.getType() == Double.class) {
                            predicate = cb.equal(root.get(fieldName), Double.valueOf(fieldValue));
                        } else if (field.getType() == String.class) {
                            predicate = cb.like(cb.lower(root.get(fieldName)), "%" + fieldValue.toLowerCase() + "%");
                        } else if (field.getType() == java.sql.Date.class) {
                            predicate = cb.equal(root.get(fieldName), java.sql.Date.valueOf(fieldValue));
                        } else if (field.getType() == Date.class) {
                            predicate = cb.equal(root.get(fieldName), FieldUtils.readField(dto, fieldName, true));
                        } else if (field.getType() == Timestamp.class) {
                            predicate = cb.equal(root.get(fieldName), Timestamp.valueOf(fieldValue));
                        } else if (field.getType().equals(DateRangeFilterDto.class)) {
                            Object objValue = FieldUtils.readField(dto, fieldName, true);
                            if (objValue instanceof DateRangeFilterDto) {
                                DateRangeFilterDto dateRangeFilter = (DateRangeFilterDto) objValue;

                                if (!utilValidate.noData(dateRangeFilter) &&
                                        !utilValidate.noData(dateRangeFilter.getField()) &&
                                        !utilValidate.noData(dateRangeFilter.getStartDate()) &&
                                        !utilValidate.noData(dateRangeFilter.getEndDate())) {

                                    if (!root.getModel().getAttributes().stream().anyMatch(a -> a.getName().equals(dateRangeFilter.getField()))) {
                                        log.warn("Skipping non-existent field: {}", dateRangeFilter.getField());
                                        continue;
                                    }

                                    // Convert String -> LocalDateTime
                                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
                                    LocalDateTime startTime = LocalDateTime.parse(dateRangeFilter.getStartDate() + " 00:00:00", formatter);
                                    LocalDateTime endTime = LocalDateTime.parse(dateRangeFilter.getEndDate() + " 23:59:59", formatter);

                                    // Ensure type matches the entity date field
                                    Expression<LocalDateTime> dateField = root.get(dateRangeFilter.getField()).as(LocalDateTime.class);
                                    predicate = cb.between(dateField, startTime, endTime);
                                }
                            }
                        } else if (field.getType().getGenericSuperclass() == BaseDto.class) {
                            Join<E, ?> join = root.join(fieldName);
                            predicate = cb.equal(join.get("id"), Long.valueOf(fieldValue));
                        } else {
                            throw new ServiceExceptionHolder.BadRequestException("Invalid type for dto search field: " + field.getType());
                        }

                        if (predicate != null) {
                            fieldPredicates.add(predicate);
                        }

                    } catch (Exception e) {
                        log.error("Error processing field: " + field.getName(), e);
                        throw new ServiceExceptionHolder.BadRequestException("Invalid field: " + field.getName());
                    }
                }

                if (!fieldPredicates.isEmpty()) {
                    Predicate combinedPredicate;

                    if (key.startsWith("or")) {
                        combinedPredicate = cb.or(fieldPredicates.toArray(new Predicate[0]));
                        orPredicates.add(combinedPredicate);
                    } else {
                        combinedPredicate = cb.and(fieldPredicates.toArray(new Predicate[0]));
                        andPredicates.add(combinedPredicate);
                    }
                }
            }

            Predicate finalPredicate = cb.and(andPredicates.toArray(new Predicate[andPredicates.size()]));

            if (!orPredicates.isEmpty()) {
                finalPredicate = cb.and(finalPredicate, cb.or(orPredicates.toArray(new Predicate[orPredicates.size()])));
            }

            // Ensure deleted data is always filtered out
            finalPredicate = cb.and(finalPredicate, cb.equal(root.get("isDeleted"), false));

            return finalPredicate;
        };
    }


}
