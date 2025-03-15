/************************************************************************
 * @description JavaScript array methods for AHK
 * @file Array.ahk
 * @author Laser Made
 * @date 3/11/2025
 * @version 1.2
 ***********************************************************************/

;JS_Array.Prototype.base := Array2
Array.Prototype.base := JS_Array
Array.DefineProp('from', {call:__arr_from})
Array.DefineProp('of', {call:__arr_of})

class JS_Array {
    static __New() {
        __ObjDefineProp := Object.Prototype.DefineProp
        /*__ObjDefineProp(Array.Prototype, "from", {get:(args*)=> JS_Array.from(args*)})*/
    }
    ;static length => this.length

    /*Static Methods*/

    /**
     * Is it possible to implement Async functions (like this) in AHK?
     */
    static fromAsync() => this._unimplemented()

    ;@returns {Boolean}
    static isArray() => (this is Array)

    /*Instance Methods*/
    /**
     * @param index - The index of the element to retrieve (can be negative to start from the end of the array)
     * {@link https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/at|MDN - at()}
     */
    static at(index) => this[index < 0 ? index + this.length : index] 

    ;static push(items*) => this.push(items*)

    /**
     * @param values - The items to add to the end of the array
     * @returns {Array} a shallow copy of the existing array on which it is called plus any included parameters as new values
     * {@link https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/concat|MDN - concat()}
     */
    static concat(arr*) {
        return this.push(arr*)
    }

    /**
     * @param target Zero-based index at which to copy the sequence to, converted to an integer. This corresponds to where the element at start will be copied to, and all elements between start and end are copied to succeeding indices.
     * @param start Zero-based index at which to start copying elements from, converted to an integer.
     * @param {Any} end Zero-based index at which to end copying elements from, converted to an integer. copyWithin() copies up to but not including end.
     * @returns {Array} this - The modified array.
     * {@link https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/copyWithin|MDN - copyWithin()}
     */
    static copyWithin(target, start, end := this.length) {
        result := this
        copyValue := this[Number(target)]
        for index, value in this {
            if index >= Number(start) && index <= end {
                result[index] := copyValue
            }
        }
        this := result
        return this
    }
    /**
     * @description functionally similar but not exactly the same as Array.entries() in JavaScript due to the lack of an iterator object in AHK
     * @returns {Array} Containing an array of key-value pairs for each index in the original array
     * {@link https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/entries|MDN - entries()}
     */
    static entries() {
        result := []
        for index, value in this {
            result.push([index, value])
        }
        return result
    }
    /**
     * @description instances tests whether all elements in the array pass the test implemented by the provided function. It returns a Boolean value.
     * @param callbackFn A function to execute for each element in the array. It should return a truthy value to indicate the element passes the test, and a falsy value otherwise
     * @returns {Boolean} true if every element satisfies the condition, else false
     */
    static every(callbackFn) {
        if (!HasMethod(callbackFn))
            throw ValueError("Every: func must be a function", -1)
        for value in this {
            if !callbackFn(value)
                return false
        }
        return true
    }
    /**
     * @param insert Value to fill the array with. Note all elements in the array will be this exact value
     * @param {Integer} start [optional] One-based index at which to start filling
     * @param {Any} end One-based index at which to end filling, converted to an integer. fill() fills up to but not including end
     * @returns {Array} The modified array, filled with the value of the parameter insert
     */
    static fill(insert, start := 1, end := this.length) {
        for index, value in this {
            if index >= start && index < end {
                this[index] := insert
            }
        }
        return this
    }

    /**
     * @description  instances creates a shallow copy of a portion of a given array, filtered down to just the elements from the given array that pass the test implemented by the provided function.
     * @param function A function to execute for each element in the array. It should return a truthy value to keep the element in the resulting array, and a falsy value otherwise.
     * @returns {Array} 
     */
    static filter(function) {
        result := []
        for index, value in this {
            try {
                if function(value, index) {
                    result.push(value)
                }
            } catch {
                if function(value) {
                    result.push(value)
                }
            }
        }
        return result    
    }

    /**
     * @param function A conditional function or expression.
     * @param start Optional: the index to start the search from. Default is 1.
     * @returns the first element in the provided array that satisfies the provided conditional function.
     * If no values satisfy the testing function, 0 is returned.
     * @example
     * [1,2,3,4].Find(item => (Mod(item, 3) == 0)) ; returns 3
     */
    static find(function, start := 1) {
        for index, value in this {
            if index >= start && function(value) {
                return value
            }
        }
        return 0
    }
    /**
     * @param function A conditional function or expression.
     * @returns the index of the first element in an array that satisfies the provided conditional function.
     * If no elements satisfy the testing function, 0 is returned.
     */
    static findIndex(function) {
        for index, value in this {
            if function(value) {
                return index
            }
        }
        return 0
    }

    /**
     * @param function A conditional function or expression.
     * @returns the last element in the provided array that satisfies the provided conditional function, 
     * If no values satisfy the testing function, 0 is returned.
     * @example
     * [1,2,3,4].Find(item => (Mod(item, 3) == 0)) ; returns 3
     */
    static findLast(function) {
        index := 0
        while (index > 0) {
            value := this[index]
            if function(value) {
                return value
            }
            index--            
        }
        return 0
/*         found := ''
        for index, value in this {
            if function(value) {
                found := value
            }
        }
        return found == '' ? 0 : found */
    }
    
    /**
     * @description iterates the array in reverse order and returns the index of the first element that satisfies the provided testing function. If no elements satisfy the testing function, 0 is returned.
     * @param function A function to execute for each element in the array. It should return a truthy value to indicate a matching element has been found, and a falsy value otherwise. The function is called with the following arguments:
     * @example
     * [1,3,2,3].findLastIndex(item => (Mod(item, 3) == 0)) ; returns 4
     */
    static findLastIndex(function) {
        index := this.length
        while (index > 0) {
            if function(this[index]) {
                return index
            }
            index--
        }
        return 0
    }

    /**
     * @description creates a new array with all sub-array elements concatenated into it recursively up to the specified depth.
     * @param {Integer} depth The depth level specifying how deep a nested array structure should be flattened. Defaults to 1.
     * @returns {Array} A new array with the sub-array elements concatenated into it.
     */
    static flat(depth := 1) {
        result := []
        depth--
        for index, value in this {
            (value is Array) ? result.push(value*) : result.push(value)
        }
        return depth == 0 ? result : result.flat(depth) 
    }

    ;same as calling this.map(callbackFn).flat()
    static flatMap(function) => this.map(function).flat()

    /**
     * Applies a function to each element in the array.
     * @param function The callback function with arguments:
     * Callback(value)
     * OR
     * Callback(index, value)
     * @returns {Array} this
     */
    static forEach(function) {
        if !HasMethod(func)
            throw ValueError("forEach: parameter must be a function", -1)
        for index, value in this
            function(value, index?)
        return this 
    }

    /**
     * @param function A conditional function or expression.
     * @param start Optional: the index to start the search from. Default is 1.
     * @returns the first element in the provided array that satisfies the provided conditional function.
     * If no values satisfy the testing function, 0 is returned.
     * @example
     * [1,2,3,4].includes(item => (Mod(item, 3) == 0)) ; returns true
     */
    static includes(search, start := 1) {
        for index, value in this {
            if index >= start && value == search {
                return true
            }
        }
        return false
    }

    /**
     * @author Descolada
     * Finds a value in the array and returns its index.
     * @param value The value to search for.
     * @param start Optional: the index to start the search from. Default is 1.
     */
    indexOf(value, start:=1) {
        if !IsInteger(start)
            throw ValueError("IndexOf: start value must be an integer")
        for i, v in this {
            if i < start
                continue
            if v == value
                return i
        }
        return 0
    }

    /**
     * @description creates and returns a new string by concatenating all of the elements in this array, separated by commas or a specified separator string. If the array has only one item, then that item will be returned without using the separator.
     * @param delimiter A string to separate each pair of adjacent elements of the array. If omitted, the array elements are separated with a comma (",").
     * @returns {String} concatenated string of all values in the array, each separated by `delimeter`
     */
    static join(delimiter := ',') {
        str := ''
        for index, value in this {
            str := str . value . (index = this.length ? '' : delimiter)
        }
        return str
    }
    /**
     * 
     * @returns {Array} returns a new array ~iterator object~ that contains the keys for each index in the array.
     */
    static keys() {
        result := []
        for index, value in this
            result.push(index)
        return result
    }

    /**
     * @param searchElement Element to locate in the array.
     * @param {Integer[optional]} fromIndex One-based index at which to start searching backwards, converted to an integer.
     * @returns instances returns the last index at which a given element can be found in the array, or -1 if it is not present. The array is searched backwards, starting at fromIndex.
     */
    static lastIndexOf(searchElement, fromIndex := this.length) {
        while (fromIndex > 0) {
            if this[fromIndex] = searchElement {
                return fromIndex
            }
            fromIndex--
        }
        return 0
    }

    /**
     * @author Descolada
     * @description Applies a function to each element in the array (mutates the array).
     * @param func The mapping function that accepts one argument.
     * @param arrays Additional arrays to be accepted in the mapping function
     * @returns {Array} A new array with each element being the result of the callback function.
     */
    static map(func, arrays*) {
        if !HasMethod(func)
            throw ValueError("Map: func must be a function", -1)
        for i, v in this {
            boundfunc := func.Bind(v?)
            for _, vv in arrays
                boundfunc := boundfunc.Bind(vv.Has(i) ? vv[i] : unset)
            try boundfunc := boundfunc()
            this[i] := boundfunc
        }
        return this
    }

    /**
     * @author Descolada
     * Applies a function cumulatively to all the values in the array, with an optional initial value.
     * @param func The function that accepts two arguments and returns one value
     * @param initialValue Optional: the starting value. If omitted, the first value in the array is used.
     * @returns {func return type}
     * @example
     * [1,2,3,4,5].Reduce((a,b) => (a+b)) ; returns 15 (the sum of all the numbers)
     */
    static reduce(func, initialValue?) {
        if !HasMethod(func)
            throw ValueError("Reduce: func must be a function", -1)
        len := this.Length + 1
        if len = 1
            return initialValue ?? ""
        if IsSet(initialValue)
            out := initialValue, i := 0
        else
            out := this[1], i := 1
        while ++i < len {
            out := func(out, this[i])
        }
        return out
    }

    static reduceRight(function, initialValue?) => this.reverse().reduce(function, initialValue?)
    
    /**
     * @author Descolada
     * Reverses the array.
     * @example
     * [1,2,3].Reverse() ; returns [3,2,1]
     */
    static reverse() {
        len := this.Length + 1, max := (len // 2), i := 0
        while ++i <= max
            this.swap(i, len - i)
        return this
    }

    /**
     * @description Shifts all values to the left by 1 and decrements the length by 1, resulting in the first element being removed. This method mutates the original array. If the length property is 0, undefined is returned.
     * @returns {Array} 
     */
    static shift() {
        newArray := []
        for index, value in this {
            if index = 1
                continue
            newArray.push(value)
        }
        this := newArray
        return newArray
    }

    /**
     * @author Descolada
     * @returns a section of the array from 'start' to 'end', optionally skipping elements with 'step'.
     * @description Modifies the original array.
     * @param start Optional: index to start from. Default is 1.
     * @param end Optional: index to end at. Can be negative. Default is 0 (includes the last element).
     * @param step Optional: an integer specifying the incrementation. Default is 1.
     * @returns {Array}
     */
    static slice(start:=1, end:=0, step:=1) {
        len := this.length, i := start < 1 ? len + start : start, j := Min(end < 1 ? len + end : end, len), r := [], reverse := False
        if len = 0
            return []
        if i < 1
            i := 1
        if step = 0
            Throw Error("Slice: step cannot be 0",-1)
        else if step < 0 {
            while i >= j {
                r.Push(this[i])
                i += step
            }
        } else {
            while i <= j {
                r.Push(this[i])
                i += step
            }
        }
        return this := r
    }

    static some(function) {
        for value in this {
            if function(value)
                return true
        }
        return false
    }

    /**
     * @author Descolada
     * Sorts an array, optionally by object keys
     * @param OptionsOrCallback Optional: either a callback function, or one of the following:
     * 
     *     N => array is considered to consist of only numeric values. This is the default option.
     *     C, C1 or COn => case-sensitive sort of strings
     *     C0 or COff => case-insensitive sort of strings
     * 
     *     The callback function should accept two parameters elem1 and elem2 and return an integer:
     *     Return integer < 0 if elem1 less than elem2
     *     Return 0 is elem1 is equal to elem2
     *     Return > 0 if elem1 greater than elem2
     * @param Key Optional: Omit it if you want to sort a array of primitive values (strings, numbers etc).
     *     If you have an array of objects, specify here the key by which contents the object will be sorted.
     * @returns {Array}
     */
    static sort(optionsOrCallback:="N", key?) {
        static sizeofFieldType := 16 ; Same on both 32-bit and 64-bit
        if HasMethod(optionsOrCallback)
            pCallback := CallbackCreate(CustomCompare.Bind(optionsOrCallback), "F Cdecl", 2), optionsOrCallback := ""
        else {
            if InStr(optionsOrCallback, "N")
                pCallback := CallbackCreate(IsSet(key) ? NumericCompareKey.Bind(key) : NumericCompare, "F CDecl", 2)
            if RegExMatch(optionsOrCallback, "i)C(?!0)|C1|COn")
                pCallback := CallbackCreate(IsSet(key) ? StringCompareKey.Bind(key,,True) : StringCompare.Bind(,,True), "F CDecl", 2)
            if RegExMatch(optionsOrCallback, "i)C0|COff")
                pCallback := CallbackCreate(IsSet(key) ? StringCompareKey.Bind(key) : StringCompare, "F CDecl", 2)
            if InStr(optionsOrCallback, "Random")
                pCallback := CallbackCreate(RandomCompare, "F CDecl", 2)
            if !IsSet(pCallback)
                throw ValueError("No valid options provided!", -1)
        }
        mFields := NumGet(ObjPtr(this) + (8 + (VerCompare(A_AhkVersion, "<2.1-") > 0 ? 3 : 5)*A_PtrSize), "Ptr") ; in v2.0: 0 is VTable. 2 is mBase, 3 is mFields, 4 is FlatVector, 5 is mLength and 6 is mCapacity
        DllCall("msvcrt.dll\qsort", "Ptr", mFields, "UInt", this.Length, "UInt", sizeofFieldType, "Ptr", pCallback, "Cdecl")
        CallbackFree(pCallback)
        if RegExMatch(optionsOrCallback, "i)R(?!a)")
            this.reverse()
        if InStr(optionsOrCallback, "U")
            this := Unique(this)
        return this

        CustomCompare(compareFunc, pFieldType1, pFieldType2) => (ValueFromFieldType(pFieldType1, &fieldValue1), ValueFromFieldType(pFieldType2, &fieldValue2), compareFunc(fieldValue1, fieldValue2))
        NumericCompare(pFieldType1, pFieldType2) => (ValueFromFieldType(pFieldType1, &fieldValue1), ValueFromFieldType(pFieldType2, &fieldValue2), (fieldValue1 > fieldValue2) - (fieldValue1 < fieldValue2))
        NumericCompareKey(key, pFieldType1, pFieldType2) => (ValueFromFieldType(pFieldType1, &fieldValue1), ValueFromFieldType(pFieldType2, &fieldValue2), (f1 := fieldValue1.HasProp("__Item") ? fieldValue1[key] : fieldValue1.%key%), (f2 := fieldValue2.HasProp("__Item") ? fieldValue2[key] : fieldValue2.%key%), (f1 > f2) - (f1 < f2))
        StringCompare(pFieldType1, pFieldType2, casesense := False) => (ValueFromFieldType(pFieldType1, &fieldValue1), ValueFromFieldType(pFieldType2, &fieldValue2), StrCompare(fieldValue1 "", fieldValue2 "", casesense))
        StringCompareKey(key, pFieldType1, pFieldType2, casesense := False) => (ValueFromFieldType(pFieldType1, &fieldValue1), ValueFromFieldType(pFieldType2, &fieldValue2), StrCompare(fieldValue1.%key% "", fieldValue2.%key% "", casesense))
        RandomCompare(pFieldType1, pFieldType2) => (Random(0, 1) ? 1 : -1)

        ValueFromFieldType(pFieldType, &fieldValue?) {
            static SYM_STRING := 0, PURE_INTEGER := 1, PURE_FLOAT := 2, SYM_MISSING := 3, SYM_OBJECT := 5
            switch SymbolType := NumGet(pFieldType + 8, "Int") {
                case PURE_INTEGER: fieldValue := NumGet(pFieldType, "Int64") 
                case PURE_FLOAT: fieldValue := NumGet(pFieldType, "Double") 
                case SYM_STRING: fieldValue := StrGet(NumGet(pFieldType, "Ptr")+2*A_PtrSize)
                case SYM_OBJECT: fieldValue := ObjFromPtrAddRef(NumGet(pFieldType, "Ptr")) 
                case SYM_MISSING: return		
            }
        }
        Unique(arr) {
            u := Map()
            for v in this
                u[v] := 1
            return [u*]
        }
    }

    /**
     * @description changes the contents of an array by removing or replacing existing elements and/or adding new elements in place.
     * @param start One-based index at which to start changing the array, converted to an integer.
     * @param deleteCount An integer indicating the number of elements in the array to remove from `start`
     * @param items The elements to add to the array, beginning from start
     * @returns {Array} An array containing the deleted elements (or an empty array)
     */
    static splice(start, deleteCount := this.length - start, items*) {
        start := Number(start)
        if -this.length <= start && start < 1
            start += this.length
        else if start < -this.length
            start := 1
        removed := this.remove(start, deleteCount)
        for i,v in items {
            this.InsertAt(start + i - 1, v)
        }       
        return removed
    }

    static toReversed() {
        result := this
        max := ((result.length + 1) // 2)
        index := 0
        while ++index <= max
            result.swap(index, result.Length + 1 - index)
        return result
    }

    static toSorted(options?, key?) {
        result := this
        return result.sort(options?, key?)

    }

    static toSpliced(start, deleteCount := this.length - start, items*) {
        result := this

        if -result.length <= start && start < 1
            start += result.length
        else if start < -result.length
            start := 1
        result.RemoveAt(start, deleteCount)
        for i,v in items {
            result.InsertAt(start + i - 1, v)
        }       
        return result
    }

    static toString() => this.join()

    static unshift(elements*) {
		
		aNew := []

		if (elements.Length == 0){
			return this.Length
		}

		; Handle case where this method is called statically with an array as first parameter
		if (elements.Length > 0 && Type(this) == "Class" && IsObject(elements[1]) && elements[1].HasProp("Length")) {
			arr := elements[1]
			elements.RemoveAt(1)
			return this.Unshift(arr, elements*)
		}
		
		for element in elements{
			aNew.Push(element)
		}

		for item in this {
			aNew.Push(item)
		}

		; Clear the original array
		this.Length := 0
		
		for item in aNew {
			this.Push(item)
		}

		; Return the new length
		return this.length
	}



        /* result := []
        itemArr := Array(items*)
        other := Array(this*)
        result.push(itemArr*)
        result.push(other*)
        MsgBox('result:' result.join())
        this := result
        MsgBox('this:' this.join())
        return this.length */

/*         result := []
        for item in items {
            result.push(item)
        }
        for thing in this {
            result.push(thing)
        }
        MsgBox('this(1): ' this.join())
        this := result
        MsgBox('this(2): ' this.join())
        return result */
        ;return this.length


/*         result := [items*]
        result.push(this*)
        this := result
        return this */

    static values() {
        result := []
        for v in this
            result.push(v)
        return result
    }

    static with(index, value) {
        if index >= this.length or index < (this.length * -1)
            throw IndexError('Index out of range')
        result := this
        result[index] := value
        return result
    }

    /*Non JavaScript Methods*/
    /**
     * @description removes `count` items from an array starting from `start`
     * @param {Integer} start One-based index to start removing items from the array
     * @param {Integer} count An integer indicating the number of elements in the array to remove.
     * @returns {Number | Array} returns the item removed (1) or an array of length equal to `count` containing the items removed
     */
    static remove(start := 1, count := 1) {
        removed := []
        for i,v in this {
            if i >= start && count > 0 {
                removed.push(this.RemoveAt(start))
                count--
            }
        }
        return removed.length = 1 ? removed[1] : removed
    }

    /**
     * @author Descolada
     * Swaps elements at indexes a and b
     * @param a First elements index to swap
     * @param b Second elements index to swap
     * @returns {Array}
     */
    static swap(a, b) {
        temp := this[b]
        this[b] := this[a]
        this[a] := temp
        return this
    }

    /**
     * @author Descolada
     * Counts the number of occurrences of a value
     * @param value The value to count. Can also be a function.
     */
    static count(value) {
        count := 0
        if HasMethod(value) {
            for _, v in this
                if value(v?)
                    count++
        } else
            for _, v in this
                if v == value
                    count++
        return count
    }

    static _unimplemented() {
        MsgBox('This functionality is not yet implemented.')
    }
}

__arr_of(this, args*) => [args*]

/**
 * @author GroggyOtter
 * @date 3/5/2025
 * @param {Object} this - Standard self-refrence from call descriptor
 * @param {Object} iterable - An iterable object.  
 *        Something that has an __Enum() method
 *        Or an object set up to act as an enumerator
 * @param {Func} [update_fn] - Function to update values each iteration.  
 *        The returned value is what is stored in the array.  
 *        Callback requires 2 parameters:  
 * 
 * * `Value` : The value of the current element.  
 * * `Index` : The current index of the element being processed.  
 * * `obj`   : Optional. If callback has a 3rd parameter, a reference  
 *   to the iterable object is included.
 * 
 *       ; update_fn callback format
 *       updater(value, index [, obj]) {
 *           ; Code here
 *           return 'some value'
 *       }
 * @example
 * arr := [1,2,3,4,5]
 * newArr := Array.from(arr, (value, index) => value * 2)
 * Peep(newArr) => [2,4,6,8,10]
 */
__arr_from(this, iterable, update_fn:=0) {
    local arr := []
        , max_params := 0
        , include_iterable := 0

    if (update_fn is Func) {                                                                        ; Verify function
        max_params := update_fn.MaxParams                                                           ; Check max params
        if (max_params < 2)                                                                         ; Error detection
            throw Error(1, A_ThisFunc, 'Parameters: ' max_params)
    }
    if (max_params > 2)                                                                             ; If at least 3 params
        include_iterable := 1                                                                       ;   Include object

    switch {                                                                                        ; Check iterable type
        case (iterable is String):                                                                  ;   Case: string (array of characters)
            loop parse iterable                                                                     ;     Parse through string
                arr.Push(process(A_LoopField, A_Index))                                             ;       Process and add item to array

        case (iterable.HasProp('__Enum') || iterable is Enumerator):                                ;   Case: Enumerable or an enumerator
            for index, value in iterable                                                            ;     For-loop through item
                ;value := value ?? '<UNSET>'
                arr.Push(process(value?, index?))                                                   ;       Process and add item to array


        case iterable.HasProp('Length'):                                                            ;   Case: is object with length property
            subarr := []
            try loop iterable.Length                                                                ;     Try Iterate through it using the length
                value := iterable.%A_Index%
                ,subarr.Push(process(value?, A_Index?))                                             ;       Process and add items to subarray
            Catch {                                                                                 ;     Catch try error
                subarr := []                                                                        ;       Reset subarr
                if iterable.HasMethod('OwnProps')                                                   ;       If OwnProps() Exists
                    for key, value in iterable.OwnProps()                                           ;         Loop through the items
                        subarr.Push(process(value?, key?))                                          ;           Add to subarray
                else err(2, A_ThisFunc, 'Type: ' Type(iterable))
            }
            if subarr.Length                                                                        ;     If any items added to subarray
                arr.Push(subarr*)                                                                   ;       Spread to the main array
        default: err(2, A_ThisFunc, 'Type: ' Type(iterable))                                        ;   Error if anything else
    }
    return arr

    err(msg_num, fn, extra?) {
        switch msg_num {
            case 1: msg := 'Invalid callback. The update_fn() function must accept at least 2 params.'
            case 2: msg := 'Iterable is not enumerable.'
                . '`nExpected: String, .__Enum() method, Enumerator, '
                . '.Length property, or OwnProps() method'
        }
        throw Error(msg, fn, extra ?? unset)
    }

    process(v?, i?) {                                                                               ; Processes each iteration's values
        if update_fn                                                                                ; if update func was provided
            if include_iterable                                                                     ;   if at least 3 params
                v := update_fn(v, i, iterable)                                                      ;     run updater w/ iterable and return
            else v := update_fn(v, i)                                                               ;   else run updater w/o iterable and return
        return v ?? '<UNSET>'                                                                       ; else return original value
    }
}
