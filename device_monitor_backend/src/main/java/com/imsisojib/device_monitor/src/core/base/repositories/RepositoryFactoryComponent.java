package com.imsisojib.device_monitor.src.core.base.repositories;


import com.imsisojib.device_monitor.src.core.base.entities.BaseEntity;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.lang.reflect.ParameterizedType;
import java.util.List;

@Component
@RequiredArgsConstructor
public class RepositoryFactoryComponent {

    private final List<BaseRepository> serviceRepositories;

    public <E extends BaseEntity> BaseRepository<E> getRepository(Class<E> entityClass) {
        //noinspection unchecked
        return (BaseRepository<E>) serviceRepositories.stream()
                .filter(sr -> isMatchingType(sr, entityClass))
                .findFirst()
                .orElse(null);
    }

    private boolean isMatchingType(BaseRepository repository, Class clazz) {
        return ((ParameterizedType) ((Class) repository.getClass()
                .getGenericInterfaces()[0])
                .getGenericInterfaces()[0])
                .getActualTypeArguments()[0]
                .getTypeName().equals(clazz.getTypeName());
    }
}