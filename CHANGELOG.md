# Change Log

All notable changes to this project will be documented in this file.


## 2.1.0 (05/20/2021)

### Added

- Support for updating and remaking items for a target section with a tag.
- Support the `updateItems` and `remakeItems` methods for `sectionMaker`.

### Fixed

- Update sections by `holo_updateSections:` method.


## 2.0.0 (05/04/2021)

### Added

- Support to reload a collection view by setting datasource with `HoloCollectionSection` and `HoloCollectionItem`. Add `holo_sections` for `UICollectionView`.
- Add `holo_sectionIndexTitles` for `UICollectionView`.
- Add `holo_sectionForSectionIndexTitleHandler` for `UICollectionView`.
- Add `holo_scrollDelegate` for `UICollectionView`.

### Updated

- Rename `row` with `item`, and replace `holo_makeRows` with `holo_makeItems`.

### Fixed

- Get reuse id from handler, if the handler exists.
- Register the cell class, header class and footer class, if they haven't been registered before.

### Removed

- No longer support `headerFooterConfigSEL`, `headerFooterHeightSEL` and `headerFooterEstimatedHeightSEL` properties.
- No longer support `itemS`, `headerS` and `footerS` properties. And no longer support to regist key-Class map (`itemsMap`, `headersMap` and `footersMap`).


## 1.4.0 (16/02/2021)

- Update `HoloCollectionView.h`, use angle-bracketed instead of double-quoted.
- Update `HoloCollectionMacro`, add `#if !defined()`.


## 1.3.0 (08/12/2020)

- Add `nullable` to property.


## 1.2.0 (12/11/2020)

- Add `beforeConfigureHandler` and `afterConfigureHandler`, performed before and after `configSEL`.


## 1.1.0 (13/08/2020)

- Add `_Nullable` to method parameters in cell protocol, header protocol and footer protocol.


## 1.0.0 (23/07/2020)

- Refactor the update, remake and insert methods for `HoloCollectionView` and optimize the code logic.
- Provide more properties of section and item maker to handle proxy events of `HoloCollectionView`.
- Provide more protocols, implemented in cells, headers and footers to handle proxy events of `HoloCollectionView`.
- Support to regist maps (key-Class) for item, header and footer.
- Check the index in `HoloCollectionViewProxy` for safety.


## 0.x (2019 ~ 2020)

`HoloCollectionView` provides chained syntax calls that encapsulate delegate methods for `UICollectionView`. The delegate methods for `UICollectionView` is distributed to each `cell`, each `cell` having its own method for setting Class, model, height, and click event, etc.


