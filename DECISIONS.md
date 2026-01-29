# DECISIONS.md - Device Monitor Project

## Project Overview
This document outlines the ambiguities identified during the development of the Device Monitor system, the design decisions made to address them, key assumptions, and questions that would be asked in a real-world scenario.

---
## 1. Ambiguities Identified

### Ambiguity 1: Device Registration and Identity Management
**Question**: How should devices be identified? What happens when users reinstall the app or switch devices?

**Options Considered**:
- **Option A**: Use device hardware ID (Android ID, identifierForVendor)
    - Pros: Persistent across app re-installs
    - Cons: Privacy concerns, permissions required, can't track multiple devices per user

- **Option B**: Generate random ID on first launch
    - Pros: Privacy-friendly, no permissions needed
    - Cons: Lost on app reinstall, can't link devices to users

- **Option C**: User account with device registration
    - Pros: Multi-device support, data synced across devices
    - Cons: Complex (auth, user management), not in requirements


**Decision**: I chose **Option A and B merging together**

**Implementation**:
- Implemented on backend service (POST: api/devices)
- For android, requested device register with 'androidId' then backend checks if there is existing device registered with this 'androidId'. If yes, then just send back the result if not then generate uniqueId and returns
- Store in SharedPreferences after registration
- On reinstall: if 'androidId' changed then new device created, otherwise persist existing device

**Reasoning**:
- Simple implementation (no auth system required)
- Meets requirement of "device monitoring" without user accounts
- User can distinguish between multiple devices via unique id

**Trade-offs Accepted**:
- Data lost on system update of any event that may change 'androidId'

**Assumptions Made**:
- Users rarely reinstall monitoring apps
- Single-device use case is primary (not multi-device per user)
- Fresh monitoring data on reinstall is acceptable

---

### Ambiguity 2: Analytics Endpoint Response Format and Metrics
**Question**: What specific analytics should be returned beyond rolling average? What time windows should be supported?

**Options Considered**:
- **Option A**: Only rolling average (simple, meets literal requirement)
    - Pros: Simple to implement, minimal server processing
    - Cons: Limited insights, doesn't help identify trends or anomalies

- **Option B**: Multiple metrics (min, max, average, standard deviation, trend direction)
    - Pros: Comprehensive insights, helps identify device health patterns
    - Cons: More complex response structure, increased server processing

- **Option C**: Time-windowed analytics (day, week, month) with configurable windows
    - Pros: Flexible, supports different analysis needs
    - Cons: Most complex, requires query parameters, potential performance issues

**Decision**: I chose **Option C with partial elements of Option B**

**Reasoning**:
- Users need more than just average to understand device health
- Standard deviation indicates stability vs. volatility
- Implemented with default time window (1M) but structured for future configurability

**Trade-offs Accepted**:
- More complex response structure requires more processing
- Increased database queries (aggregations)
- More data transferred over network
- **Benefit**: Much better user insights outweigh computational cost

**Assumptions Made**:
- Users want to understand device health trends over time
- 24-hour window is a reasonable default for mobile device monitoring
- Statistical metrics (std dev, trends) are valuable for device diagnostics

---

### Ambiguity 3: Sensor Failure Handling and Data Validation
**Question**: What happens when a sensor temporarily fails? How should we handle invalid or missing data?

**Options Considered**:
- **Option A**: Reject entire vitals submission if any field is invalid
    - Pros: Data integrity guaranteed, simple validation logic
    - Cons: Lose all data if one sensor fails, poor user experience

- **Option B**: Accept partial data, store nulls for missing sensors
    - Pros: Don't lose data from working sensors
    - Cons: Database schema complexity, analytics must handle nulls

- **Option C**: Use last known good values for failed sensors
    - Pros: Complete data records, smooth analytics
    - Cons: Inaccurate data, masks real sensor failures

- **Option D**: Accept partial data with validation ranges
    - Pros: Balance between data completeness and accuracy
    - Cons: More complex validation logic

**Decision**: I chose **Option D - Accept partial data with strict validation**

**Reasoning**:
- Real-world sensors can fail temporarily
- Losing all data due to one sensor failure is unacceptable
- Validation ranges ensure data quality:
    - Battery: 0-100%
    - Thermal status: 0-3 (Android thermal states)
    - Memory usage: 0-100%
- Invalid data is rejected with clear error messages

**Trade-offs Accepted**:
- More complex validation logic in backend
- Potential for sparse data in analytics if sensors frequently fail
- Need to handle edge cases in analytics calculations
- **Benefit**: System is resilient to sensor failures while maintaining data quality

**Assumptions Made**:
- Sensor failures are temporary and occasional, not permanent
- Users prefer partial data over no data
- Clear error messages help users diagnose sensor issues
- Invalid data should never be stored, even partially

---


## 2. Key Assumptions Summary

### User Needs
1. **Primary use case is personal device monitoring**, not enterprise fleet management
2. **Users care about battery health and thermal issues** more than raw memory numbers
3. **Visual trends are more valuable** than raw data tables
4. **Battery life of the monitoring app** is a critical concern

### System Behavior
1. **Sensor failures are temporary and occasional**, not persistent
2. **Network interruptions are common** on mobile devices
3. **1 Month window is more than enough** for most device health analysis
4. **Real-time updates** (sub-second) are not required
5. **Storage costs** will become significant over time

### Technical Constraints
1. **Mobile devices have limited resources** (battery, network)
2. **Backend should be stateless** for scalability
3. **Database should be SQL-based** for ACID guarantees and analytics queries
4. **Mobile app targets Android 7.0+** (API 24+)
5. **Network bandwidth is limited** on mobile networks

### Business Constraints
1. **No user authentication** required (simplifies MVP)
2. **No payment processing** or premium features needed
3. **Minimum 4GB server requirements** acceptable to start with
4. **Manual scaling** acceptable for MVP (no auto-scaling)
5. **Basic error monitoring** sufficient

---

## 3. Questions I Would Ask a Product Manager

### Product Vision & User Needs

1**What is the primary problem we're solving?**
    - Identifying battery drain issues?
    - Monitoring thermal throttling for gaming?
    - General device health awareness?
    - Impact: Affects which metrics to emphasize, alert thresholds

2**What are the top 3 use cases?**
    - Examples: "I want to know why my battery dies quickly", "I need to monitor app performance impact"
    - Impact: Drives feature prioritization, UI design

3**Is multi-device support required for MVP?**
    - Single device per user?
    - Multiple devices per user?
    - Impact: Authentication system, backend complexity, data model

4**Do users need to compare devices?**
    - Compare my phone vs. tablet?
    - Compare my device vs. similar models?
    - Impact: Analytics complexity, UI design

5**Should historical data be exportable?**
    - CSV export for analysis?
    - PDF reports for sharing?
    - Impact: Export feature implementation, data format decisions

6**Are notifications/alerts required?**
    - "Battery below 10%"?
    - "Device overheating"?
    - Impact: Background service requirements, notification system

7**What analytics are most valuable?**
    - Trends over time?
    - Comparisons vs. baseline?
    - Anomaly detection?
    - Impact: Backend analytics implementation, ML potential



8. **What are the monetization plans?**
    - Free app?
    - Ads?
    - Premium features?
    - Impact: Feature gating, subscriptions, analytics tracking

---

## 4. When to Seek Clarification vs. Make Independent Decisions

### Seek Clarification When:
  **Business model affects technical decisions**
- Example: "Will this be monetized?"
- Impact: Changes analytics tracking, feature gating

  **Integration with external systems**
- Example: "Must we integrate with existing tools?"
- Impact: API compatibility requirements

### Make Independent Decisions When:
  **Technical implementation details**
- Example: "Use PostgreSQL vs MySQL"
- Reasoning: Both meet requirements, can swap later

  **Code organization and architecture**
- Example: "Bloc vs. Provider State Management"
- Reasoning: Internal decision, doesn't affect product

  **Optimization techniques**
- Example: "Caching strategy for analytics"
- Reasoning: Performance optimization, can iterate
  **Edge case handling**
- 
- Example: "What if sensor returns negative value?"
- Reasoning: Technical error handling, document decision

---

The system is designed to be **good enough** for MVP while remaining **extensible** for future requirements we discover through user feedback.