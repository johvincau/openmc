from six import string_types

from openmc.checkvalue import check_type


class Macroscopic(object):
    """A Macroscopic object that can be used in a material.

    Parameters
    ----------
    name : str
        Name of the macroscopic data, e.g. UO2

    Attributes
    ----------
    name : str
        Name of the nuclide, e.g. UO2

    """

    def __init__(self, name=''):
        # Initialize class attributes
        self._name = ''

        # Set the Macroscopic class attributes
        self.name = name

    def __repr__(self):
        string = 'Macroscopic    -    {0}\n'.format(self._name)
        return string

    @property
    def name(self):
        return self._name

    @name.setter
    def name(self, name):
        check_type('name', name, string_types)
        self._name = name
