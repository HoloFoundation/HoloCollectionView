# Change Log

All notable changes to this project will be documented in this file.


## 1.2.0 (12/11/2020)

- Add `beforeConfigureHandler` and `afterConfigureHandler`, performed before and after `configSEL`.


## 1.1.0 (13/08/2020)

- Add `_Nullable` to method parameters in cell protocol, header protocol and footer protocol.


## 1.0.0 (23/07/2020)

- Refactor the update, remake and insert methods for `HoloCollectionView` and optimize the code logic.
- Provide more properties of section and row maker to handle proxy events of `HoloCollectionView`.
- Provide more protocols, implemented in cells, headers and footers to handle proxy events of `HoloCollectionView`.
- Support to regist maps (key-Class) for row, header and footer.
- Check the index in `HoloCollectionViewProxy` for safety.


## 0.x (2019 ~ 2020)

`HoloCollectionView` provides chained syntax calls that encapsulate delegate methods for `UICollectionView`. The delegate methods for `UICollectionView` is distributed to each `cell`, each `cell` having its own method for setting Class, model, height, and click event, etc.


