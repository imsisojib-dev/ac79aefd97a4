package com.imsisojib.device_monitor.src.core.base.repositories;

import com.imsisojib.device_monitor.src.core.base.entities.BaseEntity;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.repository.NoRepositoryBean;
import org.springframework.data.repository.PagingAndSortingRepository;

import java.util.List;
import java.util.Optional;
import java.util.Set;

@NoRepositoryBean
public interface BaseRepository<E extends BaseEntity> extends JpaRepository<E, Long>, PagingAndSortingRepository<E, Long>, JpaSpecificationExecutor<E> {

    Optional<E> findByIdAndIsDeleted(Long id, boolean isDeleted);

    List<E> findByIdInAndIsDeleted(Set<Long> ids, boolean isDeleted);

    List<E> findByIsDeleted(boolean isDeleted);
    Page<E> findByIsDeleted(boolean isDeleted, Pageable pageable);

    Page<E> findByIdInAndIsDeleted(Set<Long> ids, boolean isDeleted, Pageable pageable);
}

