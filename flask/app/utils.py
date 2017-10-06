def to_bool(source_bool):
    """
    Convert stringy things and other types to bools
    """
    if isinstance(source_bool, str):
        if source_bool.lower() in ['yes', 'y', 'true', 't', '2']:
            return True
        else:
            return False
    elif isinstance(source_bool, int):
        return True if source_bool else False
    elif isinstance(source_bool, bool):
        return source_bool
