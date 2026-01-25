package com.imsisojib.device_monitor.src.core.base.services;

import com.imsisojib.device_monitor.src.core.base.model.MetaModel;
import com.imsisojib.device_monitor.src.core.base.model.SortModel;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;


@Service
public class CommonUtilService {

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
        // has no sorted properties inside meta
        return PageRequest.of(meta.getPage(), meta.getLimit());
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
        orders.add(new Sort.Order(Sort.Direction.DESC, "createdOn"));
        return orders;
    }

    private Sort.Direction getDirection(String order) {
        return null != order && order.equalsIgnoreCase(Sort.Direction.DESC.toString()) ? Sort.Direction.DESC : Sort.Direction.ASC;
    }

}
